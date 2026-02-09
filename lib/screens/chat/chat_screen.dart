import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import '../../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {  
  final ChatService _chatService = ChatService();
  bool _isLoading = true;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _initializeCometChat();
  }

  Future<void> _initializeCometChat() async {
    try {
      User? loggedInUser = await _chatService.loginFromSession();

      if (mounted) {
        setState(() {
          _currentUser = loggedInUser;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Lỗi khởi tạo chat: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.chat_bubble_outline,
                  size: 80,
                  color: Color(0xFFFF69B4),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Vui lòng đăng nhập trước',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF69B4),
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Bạn cần đăng nhập vào ứng dụng trước khi sử dụng tính năng chat',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
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
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
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
              titleStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
              border: Border.all(color: Colors.transparent),
            ),
            listItemStyle: ListItemStyle(
              background: Colors.white,
              borderRadius: 16,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              padding: const EdgeInsets.all(12),
            ),
            hideAppbar: false,
            appBarOptions: <Widget>[],
          ),
        ),
      ),
    );
  }
}
