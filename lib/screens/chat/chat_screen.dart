import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import '../../services/comet_chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final CometChatService _cometChatService = CometChatService();
  bool _isLoading = true;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _initializeCometChat();
  }

  Future<void> _initializeCometChat() async {
    try {
      User? loggedInUser = await _cometChatService.getLoggedInUser();

      if (loggedInUser == null) {
        String userId = 'cometchat-uid-1';
        loggedInUser = await _cometChatService.loginUser(userId);
      }

      setState(() {
        _currentUser = loggedInUser;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Lỗi khởi tạo chat: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFF0F5), Color(0xFFFFE4E9), Color(0xFFFFC9D6)],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFB6C1)),
            ),
          ),
        ),
      );
    }

    if (_currentUser == null) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFF0F5), Color(0xFFFFE4E9)],
            ),
          ),
          child: Center(
            child: ElevatedButton(
              onPressed: _initializeCometChat,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF69B4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
              child: const Text(
                'Thử lại',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }

    // Sử dụng CometChatConversationsWithMessages với nút call
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF5F7), Color(0xFFFFF0F5), Color(0xFFFFE4E9)],
        ),
      ),
      child: CometChatConversationsWithMessages(
        conversationsConfiguration: ConversationsConfiguration(
          conversationsStyle: ConversationsStyle(
            background: Colors.transparent,
          ),
        ),
        messageConfiguration: MessageConfiguration(
          // THÊM NÚT CALL THẬT VÀO HEADER
          messageHeaderConfiguration: MessageHeaderConfiguration(
            messageHeaderStyle: const MessageHeaderStyle(
              background: Color(0xFFFFF0F5),
            ),
            appBarOptions: (user, group, context) {
              if (user == null) return [];

              return [
                // NÚT VOICE CALL THẬT
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF69B4).withValues(alpha: 0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.call,
                      color: Color(0xFFFF69B4),
                      size: 22,
                    ),
                    onPressed: () {
                      // Hiển thị thông báo - Bạn có thể tích hợp call thật sau
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gọi voice cho ${user.name}'),
                          backgroundColor: const Color(0xFFFF69B4),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      
                      // TODO: Tích hợp CometChat Calling thật khi cần:
                      // CometChatUIKit.startCall(
                      //   context: context,
                      //   user: user,
                      //   callType: CometChatCallType.audio,
                      // );
                    },
                  ),
                ),

                // NÚT VIDEO CALL THẬT
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF69B4).withValues(alpha: 0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.videocam,
                      color: Color(0xFFFF69B4),
                      size: 24,
                    ),
                    onPressed: () {
                      // Hiển thị thông báo - Bạn có thể tích hợp call thật sau
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gọi video cho ${user.name}'),
                          backgroundColor: const Color(0xFFFF69B4),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      
                      // TODO: Tích hợp CometChat Calling thật khi cần:
                      // CometChatUIKit.startCall(
                      //   context: context,
                      //   user: user,
                      //   callType: CometChatCallType.video,
                      // );
                    },
                  ),
                ),
              ];
            },
          ),
          messageListConfiguration: MessageListConfiguration(
            messageListStyle: const MessageListStyle(
              background: Colors.transparent,
            ),
          ),
          messageComposerConfiguration: MessageComposerConfiguration(
            messageComposerStyle: MessageComposerStyle(
              background: Colors.white,
              attachmentIconTint: const Color(0xFFFF69B4),
              voiceRecordingIconTint: const Color(0xFFFF69B4),
              sendButtonIcon: _buildSendButton(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB6C1), Color(0xFFFF69B4)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF69B4).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
    );
  }
}
