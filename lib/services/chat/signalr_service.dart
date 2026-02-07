import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import '../../utils/session_storage.dart';
import '../../models/chat/message.dart';
import '../../models/chat/chat_models.dart';

class SignalRService {
  static final SignalRService _instance = SignalRService._internal();
  factory SignalRService() => _instance;
  SignalRService._internal();

  HubConnection? _hubConnection;
  bool _isConnected = false;
  
  // Event streams
  final _messageReceivedController = StreamController<Message>.broadcast();
  final _typingIndicatorController = StreamController<TypingIndicator>.broadcast();
  final _userOnlineController = StreamController<int>.broadcast();
  final _userOfflineController = StreamController<OnlineStatus>.broadcast();
  final _messageReadController = StreamController<MessageReadEvent>.broadcast();
  final _messageDeletedController = StreamController<int>.broadcast();
  final _newConversationController = StreamController<int>.broadcast();
  final _removedFromConversationController = StreamController<int>.broadcast();
  final _connectionStateController = StreamController<HubConnectionState>.broadcast();

  // Getters for streams
  Stream<Message> get onMessageReceived => _messageReceivedController.stream;
  Stream<TypingIndicator> get onTypingIndicator => _typingIndicatorController.stream;
  Stream<int> get onUserOnline => _userOnlineController.stream;
  Stream<OnlineStatus> get onUserOffline => _userOfflineController.stream;
  Stream<MessageReadEvent> get onMessageRead => _messageReadController.stream;
  Stream<int> get onMessageDeleted => _messageDeletedController.stream;
  Stream<int> get onNewConversation => _newConversationController.stream;
  Stream<int> get onRemovedFromConversation => _removedFromConversationController.stream;
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

    // UserTyping event
    _hubConnection!.on('UserTyping', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final typingData = arguments[0] as Map<String, dynamic>;
          final typing = TypingIndicator.fromJson(typingData);
          _typingIndicatorController.add(typing);
        } catch (e) {
          print('SignalR: Error parsing typing indicator - $e');
        }
      }
    });

    // UserOnline event
    _hubConnection!.on('UserOnline', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final userId = arguments[0] as int;
          _userOnlineController.add(userId);
          print('SignalR: User online - $userId');
        } catch (e) {
          print('SignalR: Error parsing user online - $e');
        }
      }
    });

    // UserOffline event
    _hubConnection!.on('UserOffline', (arguments) {
      if (arguments != null && arguments.length >= 2) {
        try {
          final userId = arguments[0] as int;
          final lastSeen = arguments[1] as String?;
          final status = OnlineStatus(
            userId: userId,
            isOnline: false,
            lastSeen: lastSeen != null ? DateTime.parse(lastSeen) : null,
          );
          _userOfflineController.add(status);
          print('SignalR: User offline - $userId');
        } catch (e) {
          print('SignalR: Error parsing user offline - $e');
        }
      }
    });

    // MessageRead event
    _hubConnection!.on('MessageRead', (arguments) {
      if (arguments != null && arguments.length >= 3) {
        try {
          final conversationId = arguments[0] as int;
          final messageId = arguments[1] as int;
          final userId = arguments[2] as int;
          _messageReadController.add(MessageReadEvent(
            conversationId: conversationId,
            messageId: messageId,
            userId: userId,
          ));
          print('SignalR: Message read - $messageId by user $userId');
        } catch (e) {
          print('SignalR: Error parsing message read - $e');
        }
      }
    });

    // MessageDeleted event
    _hubConnection!.on('MessageDeleted', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final messageId = arguments[0] as int;
          _messageDeletedController.add(messageId);
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
          final conversationId = arguments[0] as int;
          _newConversationController.add(conversationId);
          print('SignalR: New conversation - $conversationId');
        } catch (e) {
          print('SignalR: Error parsing new conversation - $e');
        }
      }
    });

    // AddedToConversation event
    _hubConnection!.on('AddedToConversation', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final conversationId = arguments[0] as int;
          _newConversationController.add(conversationId);
          print('SignalR: Added to conversation - $conversationId');
        } catch (e) {
          print('SignalR: Error parsing added to conversation - $e');
        }
      }
    });

    // RemovedFromConversation event
    _hubConnection!.on('RemovedFromConversation', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final conversationId = arguments[0] as int;
          _removedFromConversationController.add(conversationId);
          print('SignalR: Removed from conversation - $conversationId');
        } catch (e) {
          print('SignalR: Error parsing removed from conversation - $e');
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
      return;
    }
    try {
      await _hubConnection!.invoke('SendTypingIndicator', args: [conversationId, isTyping]);
    } catch (e) {
      print('SignalR: Error sending typing indicator - $e');
    }
  }

  /// Get online status of users
  Future<List<OnlineStatus>> getOnlineStatus(List<int> userIds) async {
    if (!_isConnected || _hubConnection == null) {
      throw Exception('SignalR not connected');
    }
    try {
      final result = await _hubConnection!.invoke('GetOnlineStatus', args: [userIds]);
      if (result is List) {
        return result
            .map((item) => OnlineStatus.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('SignalR: Error getting online status - $e');
      return [];
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
    _typingIndicatorController.close();
    _userOnlineController.close();
    _userOfflineController.close();
    _messageReadController.close();
    _messageDeletedController.close();
    _newConversationController.close();
    _removedFromConversationController.close();
    _connectionStateController.close();
  }
}

// Helper class for message read event
class MessageReadEvent {
  final int conversationId;
  final int messageId;
  final int userId;

  MessageReadEvent({
    required this.conversationId,
    required this.messageId,
    required this.userId,
  });
}
