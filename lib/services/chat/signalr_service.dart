import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import '../../utils/session_storage.dart';
import '../../models/chat/message.dart';
import '../../models/chat/conversation.dart';
import '../../models/chat/conversation_member.dart';

class SignalRService {
  static final SignalRService _instance = SignalRService._internal();
  factory SignalRService() => _instance;
  SignalRService._internal();

  HubConnection? _hubConnection;
  bool _isConnected = false;
  
  // Event streams
  final _messageReceivedController = StreamController<Message>.broadcast();
  final _messageSeenController = StreamController<MessageSeenEvent>.broadcast();
  final _userTypingController = StreamController<TypingIndicator>.broadcast();
  final _userOnlineController = StreamController<UserOnlineEvent>.broadcast();
  final _memberAddedController = StreamController<MemberAddedEvent>.broadcast();
  final _memberRemovedController = StreamController<MemberRemovedEvent>.broadcast();
  final _conversationUpdatedController = StreamController<Conversation>.broadcast();
  final _conversationDeletedController = StreamController<int>.broadcast();
  final _messageDeletedController = StreamController<MessageDeletedEvent>.broadcast();
  final _newConversationController = StreamController<Conversation>.broadcast();
  final _connectionStateController = StreamController<HubConnectionState>.broadcast();

  // Getters for streams
  Stream<Message> get onMessageReceived => _messageReceivedController.stream;
  Stream<MessageSeenEvent> get onMessageSeen => _messageSeenController.stream;
  Stream<TypingIndicator> get onUserTyping => _userTypingController.stream;
  Stream<UserOnlineEvent> get onUserOnline => _userOnlineController.stream;
  Stream<MemberAddedEvent> get onMemberAdded => _memberAddedController.stream;
  Stream<MemberRemovedEvent> get onMemberRemoved => _memberRemovedController.stream;
  Stream<Conversation> get onConversationUpdated => _conversationUpdatedController.stream;
  Stream<int> get onConversationDeleted => _conversationDeletedController.stream;
  Stream<MessageDeletedEvent> get onMessageDeleted => _messageDeletedController.stream;
  Stream<Conversation> get onNewConversation => _newConversationController.stream;
  Stream<HubConnectionState> get onConnectionStateChanged => _connectionStateController.stream;

  bool get isConnected => _isConnected;

  /// Initialize and connect to SignalR hub
  Future<void> connect() async {
    if (_isConnected) {
      print('SignalR: Already connected');
      return;
    }

    try {
      final session = await SessionStorage.load();
      final token = session?.accessToken;

      if (token == null || token.isEmpty) {
        throw Exception('No access token available');
      }

      // Create connection
      _hubConnection = HubConnectionBuilder()
          .withUrl(
            'https://couplemood.ooguy.com/hubs/messaging',
            options: HttpConnectionOptions(
              accessTokenFactory: () async => token,
              transport: HttpTransportType.WebSockets,
              skipNegotiation: true,
            ),
          )
          .withAutomaticReconnect(
            retryDelays: [0, 2000, 5000, 10000, 30000],
          )
          .build();

      // Setup event handlers BEFORE starting connection
      _setupEventHandlers();

      // Setup connection lifecycle handlers
      _hubConnection!.onclose(({error}) {
        print('SignalR: Connection closed - ${error?.toString()}');
        _isConnected = false;
        _connectionStateController.add(HubConnectionState.Disconnected);
      });

      _hubConnection!.onreconnecting(({error}) {
        print('SignalR: Reconnecting - ${error?.toString()}');
        _isConnected = false;
        _connectionStateController.add(HubConnectionState.Reconnecting);
      });

      _hubConnection!.onreconnected(({connectionId}) {
        print('SignalR: Reconnected - $connectionId');
        _isConnected = true;
        _connectionStateController.add(HubConnectionState.Connected);
      });

      // Start connection
      await _hubConnection!.start();
      _isConnected = true;
      _connectionStateController.add(HubConnectionState.Connected);
      print('SignalR: Connected successfully');
    } catch (e) {
      print('SignalR: Connection error - $e');
      _isConnected = false;
      _connectionStateController.add(HubConnectionState.Disconnected);
      rethrow;
    }
  }

  /// Setup event handlers for receiving messages from server
  void _setupEventHandlers() {
    if (_hubConnection == null) return;

    // ReceiveMessage event
    _hubConnection!.on('ReceiveMessage', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final messageData = arguments[0] as Map<String, dynamic>;
          final message = Message.fromJson(messageData);
          _messageReceivedController.add(message);
          print('SignalR: Message received - ${message.id}');
        } catch (e) {
          print('SignalR: Error parsing message - $e');
        }
      }
    });

    // MessageSeen event
    _hubConnection!.on('MessageSeen', (arguments) {
      if (arguments != null && arguments.length >= 4) {
        try {
          final conversationId = arguments[0] as int;
          final userId = arguments[1] as int;
          final userName = arguments[2] as String;
          final messageId = arguments[3] as int;
          
          _messageSeenController.add(MessageSeenEvent(
            conversationId: conversationId,
            userId: userId,
            userName: userName,
            messageId: messageId,
          ));
          print('SignalR: Message seen - $messageId by $userName');
        } catch (e) {
          print('SignalR: Error parsing message seen - $e');
        }
      }
    });

    // UserTyping event
    _hubConnection!.on('UserTyping', (arguments) {
      print('SignalR: UserTyping event received - arguments: $arguments');
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final data = arguments[0] as Map<String, dynamic>;
          final conversationId = data['conversationId'] as int;
          final userId = data['userId'] as int;
          final userName = data['username'] as String;
          final isTyping = data['isTyping'] as bool;
          
          print('SignalR: Typing indicator - conversationId: $conversationId, userId: $userId, userName: $userName, isTyping: $isTyping');
          
          _userTypingController.add(TypingIndicator(
            conversationId: conversationId,
            userId: userId,
            userName: userName,
            isTyping: isTyping,
          ));
        } catch (e) {
          print('SignalR: Error parsing typing indicator - $e');
          print('SignalR: Arguments structure: $arguments');
        }
      }
    });

    // UserOnline event
    _hubConnection!.on('UserOnline', (arguments) {
      print('SignalR: UserOnline event received - arguments: $arguments');
      if (arguments != null && arguments.isNotEmpty) {
        try {
          // Try object format first
          if (arguments[0] is Map<String, dynamic>) {
            final data = arguments[0] as Map<String, dynamic>;
            final userId = data['userId'] as int;
            final userName = data['username'] as String? ?? data['userName'] as String? ?? '';
            final isOnline = data['isOnline'] as bool;
            
            _userOnlineController.add(UserOnlineEvent(
              userId: userId,
              userName: userName,
              isOnline: isOnline,
            ));
            print('SignalR: User online status - $userId ($userName): $isOnline');
          } else if (arguments.length >= 3) {
            // Fallback to multiple arguments format
            final userId = arguments[0] as int;
            final userName = arguments[1] as String;
            final isOnline = arguments[2] as bool;
            
            _userOnlineController.add(UserOnlineEvent(
              userId: userId,
              userName: userName,
              isOnline: isOnline,
            ));
            print('SignalR: User online status - $userId ($userName): $isOnline');
          }
        } catch (e) {
          print('SignalR: Error parsing user online - $e');
          print('SignalR: Arguments structure: $arguments');
        }
      }
    });

    // MemberAdded event
    _hubConnection!.on('MemberAdded', (arguments) {
      if (arguments != null && arguments.length >= 2) {
        try {
          final conversationId = arguments[0] as int;
          final memberData = arguments[1] as Map<String, dynamic>;
          final member = ConversationMember.fromJson(memberData);
          
          _memberAddedController.add(MemberAddedEvent(
            conversationId: conversationId,
            member: member,
          ));
          print('SignalR: Member added to conversation $conversationId');
        } catch (e) {
          print('SignalR: Error parsing member added - $e');
        }
      }
    });

    // MemberRemoved event
    _hubConnection!.on('MemberRemoved', (arguments) {
      if (arguments != null && arguments.length >= 3) {
        try {
          final conversationId = arguments[0] as int;
          final memberId = arguments[1] as int;
          final memberName = arguments[2] as String;
          
          _memberRemovedController.add(MemberRemovedEvent(
            conversationId: conversationId,
            memberId: memberId,
            memberName: memberName,
          ));
          print('SignalR: Member removed from conversation $conversationId');
        } catch (e) {
          print('SignalR: Error parsing member removed - $e');
        }
      }
    });

    // ConversationUpdated event
    _hubConnection!.on('ConversationUpdated', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final conversationData = arguments[0] as Map<String, dynamic>;
          final conversation = Conversation.fromJson(conversationData);
          
          _conversationUpdatedController.add(conversation);
          print('SignalR: Conversation updated - ${conversation.id}');
        } catch (e) {
          print('SignalR: Error parsing conversation updated - $e');
        }
      }
    });

    // ConversationDeleted event
    _hubConnection!.on('ConversationDeleted', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final conversationId = arguments[0] as int;
          _conversationDeletedController.add(conversationId);
          print('SignalR: Conversation deleted - $conversationId');
        } catch (e) {
          print('SignalR: Error parsing conversation deleted - $e');
        }
      }
    });

    // MessageDeleted event
    _hubConnection!.on('MessageDeleted', (arguments) {
      if (arguments != null && arguments.length >= 2) {
        try {
          final conversationId = arguments[0] as int;
          final messageId = arguments[1] as int;
          
          _messageDeletedController.add(MessageDeletedEvent(
            conversationId: conversationId,
            messageId: messageId,
          ));
          print('SignalR: Message deleted - $messageId');
        } catch (e) {
          print('SignalR: Error parsing message deleted - $e');
        }
      }
    });

    // NewConversation event
    _hubConnection!.on('NewConversation', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final conversationData = arguments[0] as Map<String, dynamic>;
          final conversation = Conversation.fromJson(conversationData);
          
          _newConversationController.add(conversation);
          print('SignalR: New conversation received - ${conversation.id}');
        } catch (e) {
          print('SignalR: Error parsing new conversation - $e');
        }
      }
    });
  }

  // ==================== CLIENT → SERVER METHODS ====================

  /// Join a conversation room
  Future<void> joinConversation(int conversationId) async {
    if (!_isConnected || _hubConnection == null) {
      throw Exception('SignalR not connected');
    }
    try {
      await _hubConnection!.invoke('JoinConversation', args: [conversationId]);
      print('SignalR: Joined conversation - $conversationId');
    } catch (e) {
      print('SignalR: Error joining conversation - $e');
      rethrow;
    }
  }

  /// Leave a conversation room
  Future<void> leaveConversation(int conversationId) async {
    if (!_isConnected || _hubConnection == null) {
      print('SignalR: Not connected, skipping leave conversation');
      return;
    }
    try {
      await _hubConnection!.invoke('LeaveConversation', args: [conversationId]);
      print('SignalR: Left conversation - $conversationId');
    } catch (e) {
      print('SignalR: Error leaving conversation - $e');
    }
  }

  /// Send typing indicator
  Future<void> sendTypingIndicator(int conversationId, bool isTyping) async {
    if (!_isConnected || _hubConnection == null) {
      print('SignalR: Cannot send typing indicator - not connected');
      return;
    }
    try {
      print('SignalR: Sending typing indicator - conversationId: $conversationId, isTyping: $isTyping');
      await _hubConnection!.invoke('SendTypingIndicator', args: [conversationId, isTyping]);
      print('SignalR: Typing indicator sent successfully');
    } catch (e) {
      print('SignalR: Error sending typing indicator - $e');
    }
  }

  /// Update online status
  Future<void> updateOnlineStatus(bool isOnline) async {
    if (!_isConnected || _hubConnection == null) {
      return;
    }
    try {
      await _hubConnection!.invoke('UpdateOnlineStatus', args: [isOnline]);
      print('SignalR: Updated online status - $isOnline');
    } catch (e) {
      print('SignalR: Error updating online status - $e');
    }
  }

  /// Disconnect from SignalR hub
  Future<void> disconnect() async {
    if (_hubConnection != null) {
      await _hubConnection!.stop();
      _isConnected = false;
      _connectionStateController.add(HubConnectionState.Disconnected);
      print('SignalR: Disconnected');
    }
  }

  /// Dispose all resources
  void dispose() {
    _messageReceivedController.close();
    _messageSeenController.close();
    _userTypingController.close();
    _userOnlineController.close();
    _memberAddedController.close();
    _memberRemovedController.close();
    _conversationUpdatedController.close();
    _conversationDeletedController.close();
    _messageDeletedController.close();
    _newConversationController.close();
    _connectionStateController.close();
  }
}

// ==================== EVENT MODELS ====================

class MessageSeenEvent {
  final int conversationId;
  final int userId;
  final String userName;
  final int messageId;

  MessageSeenEvent({
    required this.conversationId,
    required this.userId,
    required this.userName,
    required this.messageId,
  });
}

class TypingIndicator {
  final int conversationId;
  final int userId;
  final String userName;
  final bool isTyping;

  TypingIndicator({
    required this.conversationId,
    required this.userId,
    required this.userName,
    required this.isTyping,
  });
}

class UserOnlineEvent {
  final int userId;
  final String userName;
  final bool isOnline;

  UserOnlineEvent({
    required this.userId,
    required this.userName,
    required this.isOnline,
  });
}

class MemberAddedEvent {
  final int conversationId;
  final ConversationMember member;

  MemberAddedEvent({
    required this.conversationId,
    required this.member,
  });
}

class MemberRemovedEvent {
  final int conversationId;
  final int memberId;
  final String memberName;

  MemberRemovedEvent({
    required this.conversationId,
    required this.memberId,
    required this.memberName,
  });
}

class MessageDeletedEvent {
  final int conversationId;
  final int messageId;

  MessageDeletedEvent({
    required this.conversationId,
    required this.messageId,
  });
}
