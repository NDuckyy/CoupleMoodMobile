import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../models/chat/conversation.dart';
import '../../models/chat/conversation_member.dart';
import '../../models/chat/message.dart';
import '../../models/chat/chat_models.dart';
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
  StreamSubscription? _typingIndicatorSub;
  StreamSubscription? _userOnlineSub;
  StreamSubscription? _userOfflineSub;
  StreamSubscription? _messageReadSub;
  StreamSubscription? _messageDeletedSub;
  StreamSubscription? _newConversationSub;
  StreamSubscription? _removedFromConversationSub;

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
      // Load current user ID
      final session = await SessionStorage.load();
      _currentUserId = session?.userId;

      // Connect to SignalR
      await _signalR.connect();

      // Setup event listeners
      _setupSignalRListeners();

      // Load conversations
      await loadConversations();
    } catch (e) {
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

    // Typing indicator
    _typingIndicatorSub = _signalR.onTypingIndicator.listen((typing) {
      _handleTypingIndicator(typing);
    });

    // User online
    _userOnlineSub = _signalR.onUserOnline.listen((userId) {
      _updateUserOnlineStatus(userId, true);
    });

    // User offline
    _userOfflineSub = _signalR.onUserOffline.listen((status) {
      _updateUserOnlineStatus(status.userId, false);
    });

    // Message read
    _messageReadSub = _signalR.onMessageRead.listen((event) {
      _handleMessageRead(event);
    });

    // Message deleted
    _messageDeletedSub = _signalR.onMessageDeleted.listen((messageId) {
      _handleMessageDeleted(messageId);
    });

    // New conversation
    _newConversationSub = _signalR.onNewConversation.listen((conversationId) {
      _handleNewConversation(conversationId);
    });

    // Removed from conversation
    _removedFromConversationSub = _signalR.onRemovedFromConversation.listen((conversationId) {
      _handleRemovedFromConversation(conversationId);
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

      final messages = messagesPage.messages
          .map((m) => Message.fromJson(m))
          .toList();

      if (loadMore) {
        // Append to existing messages
        _messagesByConversation[conversationId] = [
          ...(_messagesByConversation[conversationId] ?? []),
          ...messages,
        ];
      } else {
        // Replace messages
        _messagesByConversation[conversationId] = messages;
      }

      _currentPage[conversationId] = page;
      _hasMoreMessages[conversationId] = messagesPage.hasNextPage;
      _loadingMessages[conversationId] = false;
      notifyListeners();

      // Mark as read
      if (messages.isNotEmpty) {
        await markAsRead(conversationId, messages.first.id);
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
        id: DateTime.now().millisecondsSinceEpoch, // Temporary ID
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
      final sentMessage = await MessagingApiService.sendTextMessage(
        conversationId: conversationId,
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

  /// Mark messages as read
  Future<void> markAsRead(int conversationId, int messageId) async {
    try {
      await MessagingApiService.markAsRead(
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
  Future<Conversation?> createGroupConversation(String name, List<int> memberIds) async {
    try {
      final conversation = await MessagingApiService.createGroupConversation(
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

  void _handleMessageRead(MessageReadEvent event) {
    // Update message status to read
    final messages = _messagesByConversation[event.conversationId];
    if (messages != null) {
      for (var i = 0; i < messages.length; i++) {
        if (messages[i].id <= event.messageId && messages[i].isMine) {
          messages[i] = messages[i].copyWith(status: MessageStatus.read);
        }
      }
      notifyListeners();
    }
  }

  void _handleMessageDeleted(int messageId) {
    // Remove message from all conversations
    _messagesByConversation.forEach((conversationId, messages) {
      messages.removeWhere((m) => m.id == messageId);
    });
    notifyListeners();
  }

  void _handleNewConversation(int conversationId) async {
    // Load the new conversation
    try {
      final conversation = await MessagingApiService.getConversationById(conversationId);
      _conversations.insert(0, conversation);
      notifyListeners();
    } catch (e) {
      print('Error loading new conversation: $e');
    }
  }

  void _handleRemovedFromConversation(int conversationId) {
    _conversations.removeWhere((c) => c.id == conversationId);
    _messagesByConversation.remove(conversationId);
    notifyListeners();
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
    _typingIndicatorSub?.cancel();
    _userOnlineSub?.cancel();
    _userOfflineSub?.cancel();
    _messageReadSub?.cancel();
    _messageDeletedSub?.cancel();
    _newConversationSub?.cancel();
    _removedFromConversationSub?.cancel();
    _signalR.disconnect();
    super.dispose();
  }
}
