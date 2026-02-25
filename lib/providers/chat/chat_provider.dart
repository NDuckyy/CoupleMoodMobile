import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../models/chat/conversation.dart';
import '../../models/chat/conversation_member.dart';
import '../../models/chat/message.dart';
import '../../services/chat/messaging_api_service.dart';
import '../../services/chat/signalr_service.dart';
import '../../utils/session_storage.dart';

class ChatProvider with ChangeNotifier {
  final SignalRService _signalR = SignalRService();
  
  // State
  List<Conversation> _conversations = [];
  Map<int, List<Message>> _messagesByConversation = {};
  Map<int, bool> _loadingMessages = {};
  Map<int, int> _currentPage = {};
  Map<int, bool> _hasMoreMessages = {};
  Map<int, Set<int>> _typingUsers = {};
  
  bool _isLoadingConversations = false;
  String? _error;
  int? _currentUserId;
  
  // Subscriptions
  StreamSubscription? _messageReceivedSub;
  StreamSubscription? _messageSeenSub;
  StreamSubscription? _typingIndicatorSub;
  StreamSubscription? _userOnlineSub;
  StreamSubscription? _memberAddedSub;
  StreamSubscription? _memberRemovedSub;
  StreamSubscription? _conversationUpdatedSub;
  StreamSubscription? _conversationDeletedSub;
  StreamSubscription? _messageDeletedSub;
  StreamSubscription? _newConversationSub;

  // Getters
  List<Conversation> get conversations => _conversations;
  bool get isLoadingConversations => _isLoadingConversations;
  String? get error => _error;
  int? get currentUserId => _currentUserId;
  bool get isConnected => _signalR.isConnected;

  List<Message> getMessages(int conversationId) {
    return _messagesByConversation[conversationId] ?? [];
  }

  bool isLoadingMessages(int conversationId) {
    return _loadingMessages[conversationId] ?? false;
  }

  bool hasMoreMessages(int conversationId) {
    return _hasMoreMessages[conversationId] ?? true;
  }

  Set<int> getTypingUsers(int conversationId) {
    return _typingUsers[conversationId] ?? {};
  }

  /// Initialize chat provider
  Future<void> initialize() async {
    try {
      // Load current user ID from session
      final session = await SessionStorage.load();
      _currentUserId = session?.userId;
      print('ChatProvider initialized - currentUserId: $_currentUserId');

      // Connect to SignalR
      await _signalR.connect();
      
      // Update online status
      await _signalR.updateOnlineStatus(true);

      // Setup event listeners
      _setupSignalRListeners();

      // Load conversations
      await loadConversations();
    } catch (e) {
      print('ChatProvider initialization error: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Setup SignalR event listeners
  void _setupSignalRListeners() {
    // Message received
    _messageReceivedSub = _signalR.onMessageReceived.listen((message) {
      _handleMessageReceived(message);
    });

    // Message seen
    _messageSeenSub = _signalR.onMessageSeen.listen((event) {
      _handleMessageSeen(event);
    });

    // Typing indicator
    _typingIndicatorSub = _signalR.onUserTyping.listen((typing) {
      _handleTypingIndicator(typing);
    });

    // User online
    _userOnlineSub = _signalR.onUserOnline.listen((event) {
      _updateUserOnlineStatus(event.userId, event.isOnline);
    });

    // Member added
    _memberAddedSub = _signalR.onMemberAdded.listen((event) {
      _handleMemberAdded(event);
    });

    // Member removed
    _memberRemovedSub = _signalR.onMemberRemoved.listen((event) {
      _handleMemberRemoved(event);
    });

    // Conversation updated
    _conversationUpdatedSub = _signalR.onConversationUpdated.listen((conversation) {
      _handleConversationUpdated(conversation);
    });

    // Conversation deleted
    _conversationDeletedSub = _signalR.onConversationDeleted.listen((conversationId) {
      _handleConversationDeleted(conversationId);
    });

    // Message deleted
    _messageDeletedSub = _signalR.onMessageDeleted.listen((event) {
      _handleMessageDeleted(event);
    });

    // New conversation
    _newConversationSub = _signalR.onNewConversation.listen((conversation) {
      _handleNewConversation(conversation);
    });
  }

  /// Load all conversations
  Future<void> loadConversations() async {
    _isLoadingConversations = true;
    _error = null;
    notifyListeners();

    try {
      _conversations = await MessagingApiService.getAllConversations();
      _isLoadingConversations = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingConversations = false;
      notifyListeners();
    }
  }

  /// Load messages for a conversation
  Future<void> loadMessages(int conversationId, {bool loadMore = false}) async {
    if (_loadingMessages[conversationId] == true) return;

    _loadingMessages[conversationId] = true;
    notifyListeners();

    try {
      final page = loadMore ? (_currentPage[conversationId] ?? 1) + 1 : 1;
      final messagesPage = await MessagingApiService.getMessages(
        conversationId: conversationId,
        pageNumber: page,
        pageSize: 50,
      );

      if (loadMore) {
        // Append to existing messages
        _messagesByConversation[conversationId] = [
          ...(_messagesByConversation[conversationId] ?? []),
          ...messagesPage.messages,
        ];
      } else {
        // Replace messages
        _messagesByConversation[conversationId] = messagesPage.messages;
      }

      _currentPage[conversationId] = page;
      _hasMoreMessages[conversationId] = messagesPage.hasNextPage;
      _loadingMessages[conversationId] = false;
      notifyListeners();

      // Mark latest message as read
      if (messagesPage.messages.isNotEmpty) {
        final latestMessage = messagesPage.messages.first;
        await markMessageAsRead(conversationId, latestMessage.id);
      }
    } catch (e) {
      _loadingMessages[conversationId] = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Send a text message
  Future<Message?> sendTextMessage(int conversationId, String content) async {
    try {
      // Create optimistic message
      final optimisticMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch,
        conversationId: conversationId,
        senderId: _currentUserId ?? 0,
        senderName: 'You',
        content: content,
        messageType: 'TEXT',
        createdAt: DateTime.now(),
        isMine: true,
        status: MessageStatus.sending,
        localId: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      // Add to UI immediately
      _addMessageToConversation(conversationId, optimisticMessage);

      // Send to server
      final sentMessage = await MessagingApiService.sendMessage(
        conversationId: conversationId,
        messageType: 'TEXT',
        content: content,
      );

      // Replace optimistic message with real one
      _replaceOptimisticMessage(conversationId, optimisticMessage.localId!, sentMessage);

      return sentMessage;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Send file message
  Future<Message?> sendFileMessage({
    required int conversationId,
    required String messageType,
    required String fileUrl,
    required String fileName,
    required int fileSize,
  }) async {
    try {
      final sentMessage = await MessagingApiService.sendMessage(
        conversationId: conversationId,
        messageType: messageType,
        fileUrl: fileUrl,
        fileName: fileName,
        fileSize: fileSize,
      );

      _addMessageToConversation(conversationId, sentMessage);
      return sentMessage;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Send typing indicator
  Future<void> sendTypingIndicator(int conversationId, bool isTyping) async {
    try {
      await _signalR.sendTypingIndicator(conversationId, isTyping);
    } catch (e) {
      print('Error sending typing indicator: $e');
    }
  }

  /// Join conversation room
  Future<void> joinConversation(int conversationId) async {
    try {
      await _signalR.joinConversation(conversationId);
    } catch (e) {
      print('Error joining conversation: $e');
    }
  }

  /// Leave conversation room
  Future<void> leaveConversation(int conversationId) async {
    try {
      await _signalR.leaveConversation(conversationId);
    } catch (e) {
      print('Error leaving conversation: $e');
    }
  }

  /// Mark message as read
  Future<void> markMessageAsRead(int conversationId, int messageId) async {
    try {
      await MessagingApiService.markMessageAsRead(
        conversationId: conversationId,
        messageId: messageId,
      );

      // Update unread count locally
      final index = _conversations.indexWhere((c) => c.id == conversationId);
      if (index != -1) {
        _conversations[index] = _conversations[index].copyWith(unreadCount: 0);
        notifyListeners();
      }
    } catch (e) {
      print('Error marking as read: $e');
    }
  }

  /// Delete a message
  Future<void> deleteMessage(int messageId) async {
    try {
      await MessagingApiService.deleteMessage(messageId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Create or get direct conversation
  Future<Conversation?> getOrCreateDirectConversation(int otherUserId) async {
    try {
      final conversation = await MessagingApiService.getOrCreateDirectConversation(otherUserId);
      
      // Add to list if not exists
      final index = _conversations.indexWhere((c) => c.id == conversation.id);
      if (index == -1) {
        _conversations.insert(0, conversation);
      } else {
        _conversations[index] = conversation;
      }
      notifyListeners();
      
      return conversation;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Create group conversation
  Future<Conversation?> createGroupConversation({
    required String name,
    required List<int> memberIds,
  }) async {
    try {
      final conversation = await MessagingApiService.createConversation(
        type: 'GROUP',
        name: name,
        memberIds: memberIds,
      );
      
      _conversations.insert(0, conversation);
      notifyListeners();
      
      return conversation;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Add members to group
  Future<bool> addMembersToGroup(int conversationId, List<int> memberIds) async {
    try {
      await MessagingApiService.addMembersToGroup(
        conversationId: conversationId,
        memberIds: memberIds,
      );
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Remove member from group
  Future<bool> removeMemberFromGroup(int conversationId, int memberId) async {
    try {
      await MessagingApiService.removeMemberFromGroup(
        conversationId: conversationId,
        memberId: memberId,
      );
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Leave conversation
  Future<bool> leaveConversationPermanently(int conversationId) async {
    try {
      await MessagingApiService.leaveConversation(conversationId);
      
      _conversations.removeWhere((c) => c.id == conversationId);
      _messagesByConversation.remove(conversationId);
      notifyListeners();
      
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ==================== EVENT HANDLERS ====================

  void _handleMessageReceived(Message message) {
    // Add message to conversation
    _addMessageToConversation(message.conversationId, message);

    // Update last message in conversation list
    final index = _conversations.indexWhere((c) => c.id == message.conversationId);
    if (index != -1) {
      final conversation = _conversations[index];
      final updatedConversation = conversation.copyWith(
        lastMessage: message,
        unreadCount: message.isMine ? 0 : conversation.unreadCount + 1,
      );
      
      // Move to top
      _conversations.removeAt(index);
      _conversations.insert(0, updatedConversation);
      notifyListeners();
    }
  }

  void _handleMessageSeen(MessageSeenEvent event) {
    // Update message status to seen
    final messages = _messagesByConversation[event.conversationId];
    if (messages != null) {
      for (var i = 0; i < messages.length; i++) {
        if (messages[i].senderId == _currentUserId && messages[i].id <= event.messageId) {
          messages[i] = messages[i].copyWith(status: MessageStatus.read);
        }
      }
      notifyListeners();
    }
  }

  void _handleTypingIndicator(TypingIndicator typing) {
    if (typing.userId == _currentUserId) return; // Ignore own typing

    final users = _typingUsers[typing.conversationId] ?? {};
    if (typing.isTyping) {
      users.add(typing.userId);
    } else {
      users.remove(typing.userId);
    }
    _typingUsers[typing.conversationId] = users;
    notifyListeners();
  }

  void _updateUserOnlineStatus(int userId, bool isOnline) {
    for (var i = 0; i < _conversations.length; i++) {
      final conversation = _conversations[i];
      
      // Update otherUser if DIRECT conversation
      if (conversation.type == 'DIRECT' && conversation.otherUser?.userId == userId) {
        final updatedOtherUser = conversation.otherUser!.copyWith(isOnline: isOnline);
        _conversations[i] = conversation.copyWith(otherUser: updatedOtherUser);
      }
      
      // Update in members list
      final memberIndex = conversation.members.indexWhere((m) => m.userId == userId);
      if (memberIndex != -1) {
        final updatedMember = conversation.members[memberIndex].copyWith(isOnline: isOnline);
        final updatedMembers = List<ConversationMember>.from(conversation.members);
        updatedMembers[memberIndex] = updatedMember;
        
        _conversations[i] = conversation.copyWith(members: updatedMembers);
      }
    }
    notifyListeners();
  }

  void _handleMemberAdded(MemberAddedEvent event) {
    final index = _conversations.indexWhere((c) => c.id == event.conversationId);
    if (index != -1) {
      final conversation = _conversations[index];
      final updatedMembers = [...conversation.members, event.member];
      _conversations[index] = conversation.copyWith(members: updatedMembers);
      notifyListeners();
    }
  }

  void _handleMemberRemoved(MemberRemovedEvent event) {
    final index = _conversations.indexWhere((c) => c.id == event.conversationId);
    if (index != -1) {
      final conversation = _conversations[index];
      final updatedMembers = conversation.members.where((m) => m.userId != event.memberId).toList();
      _conversations[index] = conversation.copyWith(members: updatedMembers);
      notifyListeners();
    }
  }

  void _handleConversationUpdated(Conversation conversation) {
    final index = _conversations.indexWhere((c) => c.id == conversation.id);
    if (index != -1) {
      _conversations[index] = conversation;
    } else {
      _conversations.insert(0, conversation);
    }
    notifyListeners();
  }

  void _handleConversationDeleted(int conversationId) {
    _conversations.removeWhere((c) => c.id == conversationId);
    _messagesByConversation.remove(conversationId);
    notifyListeners();
  }

  void _handleMessageDeleted(MessageDeletedEvent event) {
    final messages = _messagesByConversation[event.conversationId];
    if (messages != null) {
      messages.removeWhere((m) => m.id == event.messageId);
      notifyListeners();
    }
  }

  void _handleNewConversation(Conversation conversation) {
    // Check if conversation already exists
    final index = _conversations.indexWhere((c) => c.id == conversation.id);
    if (index == -1) {
      // Add new conversation to the top of the list
      _conversations.insert(0, conversation);
      notifyListeners();
      print('ChatProvider: New conversation added - ${conversation.id}');
    } else {
      // Update existing conversation
      _conversations[index] = conversation;
      notifyListeners();
      print('ChatProvider: Conversation updated - ${conversation.id}');
    }
  }

  // ==================== HELPER METHODS ====================

  void _addMessageToConversation(int conversationId, Message message) {
    final messages = _messagesByConversation[conversationId] ?? [];
    
    // Check if message already exists
    if (!messages.any((m) => m.id == message.id)) {
      messages.insert(0, message);
      _messagesByConversation[conversationId] = messages;
      notifyListeners();
    }
  }

  void _replaceOptimisticMessage(int conversationId, String localId, Message realMessage) {
    final messages = _messagesByConversation[conversationId];
    if (messages != null) {
      final index = messages.indexWhere((m) => m.localId == localId);
      if (index != -1) {
        messages[index] = realMessage;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _messageReceivedSub?.cancel();
    _messageSeenSub?.cancel();
    _typingIndicatorSub?.cancel();
    _userOnlineSub?.cancel();
    _memberAddedSub?.cancel();
    _memberRemovedSub?.cancel();
    _conversationUpdatedSub?.cancel();
    _conversationDeletedSub?.cancel();
    _messageDeletedSub?.cancel();
    _newConversationSub?.cancel();
    _conversationDeletedSub?.cancel();
    _messageDeletedSub?.cancel();
    
    // Update online status before disconnect
    _signalR.updateOnlineStatus(false);
    _signalR.disconnect();
    
    super.dispose();
  }
}
