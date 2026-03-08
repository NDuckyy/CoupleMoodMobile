import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/chat/chat_provider.dart';
import '../../models/chat/conversation.dart';
import '../../models/chat/message.dart';
import '../../widgets/chat/message_bubble.dart';
import '../../widgets/chat/typing_indicator.dart';
import '../../widgets/chat/message_input.dart';
import 'conversation_details_screen.dart';

class ChatScreen extends StatefulWidget {
  final Conversation conversation;

  const ChatScreen({super.key, required this.conversation});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  Timer? _typingTimer;
  bool _isTyping = false;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _initialize() async {
    final chatProvider = context.read<ChatProvider>();

    // Join conversation room
    await chatProvider.joinConversation(widget.conversation.id);

    // Load messages
    await chatProvider.loadMessages(widget.conversation.id);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreMessages();
    }
  }

  Future<void> _loadMoreMessages() async {
    if (_isLoadingMore) return;

    final chatProvider = context.read<ChatProvider>();
    if (!chatProvider.hasMoreMessages(widget.conversation.id)) return;

    setState(() => _isLoadingMore = true);
    await chatProvider.loadMessages(widget.conversation.id, loadMore: true);
    setState(() => _isLoadingMore = false);
  }

  void _handleTextChanged(String text) {
    final chatProvider = context.read<ChatProvider>();

    if (text.isNotEmpty && !_isTyping) {
      _isTyping = true;
      print(
        'ChatScreen: User started typing in conversation ${widget.conversation.id}',
      );
      chatProvider.sendTypingIndicator(widget.conversation.id, true);

      // Auto-stop typing after 3 seconds
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 3), () {
        _isTyping = false;
        print('ChatScreen: Auto-stop typing after 3 seconds');
        chatProvider.sendTypingIndicator(widget.conversation.id, false);
      });
    } else if (text.isEmpty && _isTyping) {
      _isTyping = false;
      _typingTimer?.cancel();
      print('ChatScreen: User stopped typing (text cleared)');
      chatProvider.sendTypingIndicator(widget.conversation.id, false);
    } else if (text.isNotEmpty && _isTyping) {
      // Reset timer if still typing
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 3), () {
        _isTyping = false;
        print('ChatScreen: Auto-stop typing after 3 seconds');
        chatProvider.sendTypingIndicator(widget.conversation.id, false);
      });
    }
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    // Stop typing indicator
    if (_isTyping) {
      _isTyping = false;
      _typingTimer?.cancel();
      context.read<ChatProvider>().sendTypingIndicator(
        widget.conversation.id,
        false,
      );
    }

    // Clear input
    _textController.clear();

    // Send message
    final chatProvider = context.read<ChatProvider>();
    await chatProvider.sendTextMessage(widget.conversation.id, text);

    // Scroll to bottom
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendDatePlan() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    // Stop typing indicator
    if (_isTyping) {
      _isTyping = false;
      _typingTimer?.cancel();
      context.read<ChatProvider>().sendTypingIndicator(
        widget.conversation.id,
        false,
      );
    }

    // Clear input
    _textController.clear();

    // Send message
    final chatProvider = context.read<ChatProvider>();
    await chatProvider.sendTextMessage(widget.conversation.id, text);

    // Scroll to bottom
    _scrollToBottom();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final chatProvider = context.read<ChatProvider>();

    if (state == AppLifecycleState.paused) {
      // App going to background
      chatProvider.leaveConversation(widget.conversation.id);
    } else if (state == AppLifecycleState.resumed) {
      // App coming to foreground
      chatProvider.joinConversation(widget.conversation.id);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _textController.dispose();
    _typingTimer?.cancel();

    // Leave conversation
    context.read<ChatProvider>().leaveConversation(widget.conversation.id);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final currentUserId = chatProvider.currentUserId ?? 0;
    final displayName = widget.conversation.getDisplayName();
    final isOnline = widget.conversation.getOnlineStatus();
    final messages = chatProvider.getMessages(widget.conversation.id);
    final isLoading = chatProvider.isLoadingMessages(widget.conversation.id);
    final typingUsers = chatProvider.getTypingUsers(widget.conversation.id);

    // Debug log
    if (typingUsers.isNotEmpty) {
      print(
        'ChatScreen: Typing users updated - ${typingUsers.length} users: $typingUsers',
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: InkWell(
          onTap: widget.conversation.type == 'GROUP'
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConversationDetailsScreen(
                        conversation: widget.conversation,
                      ),
                    ),
                  );
                }
              : null,
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
                backgroundImage: widget.conversation.getDisplayAvatar() != null
                    ? NetworkImage(widget.conversation.getDisplayAvatar()!)
                    : null,
                onBackgroundImageError:
                    widget.conversation.getDisplayAvatar() != null
                    ? (exception, stackTrace) {
                        print(
                          'Error loading avatar in chat screen: $exception',
                        );
                      }
                    : null,
                child: widget.conversation.getDisplayAvatar() == null
                    ? widget.conversation.type == 'GROUP'
                          ? const Icon(Icons.group, size: 20)
                          : Text(
                              displayName[0].toUpperCase(),
                              style: const TextStyle(fontSize: 16),
                            )
                    : null,
              ),
              const SizedBox(width: 12),

              // Name and status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.conversation.type == 'DIRECT')
                      Text(
                        isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontSize: 12,
                          color: isOnline ? Colors.green : Colors.grey,
                        ),
                      )
                    else
                      Text(
                        '${widget.conversation.members.length} members',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement message search
            },
          ),
          if (widget.conversation.type == 'GROUP')
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConversationDetailsScreen(
                      conversation: widget.conversation,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: isLoading && messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Chua có tin nhắn nào',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Gửi một tin nhắn để bắt đầu cuộc trò chuyện',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: messages.length + (_isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_isLoadingMore && index == messages.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final message = messages[index];
                      final showDateHeader = _shouldShowDateHeader(
                        messages,
                        index,
                      );
                      final showAvatar = _shouldShowAvatar(
                        messages,
                        index,
                        widget.conversation.type,
                      );

                      return Column(
                        children: [
                          if (showDateHeader)
                            _DateHeader(date: message.createdAt),
                          MessageBubble(
                            message: message,
                            showAvatar: showAvatar,
                            isGroupChat: widget.conversation.type == 'GROUP',
                            onDelete: message.isMine
                                ? () => _deleteMessage(message.id)
                                : null,
                          ),
                        ],
                      );
                    },
                  ),
          ),

          // Typing indicator
          if (typingUsers.isNotEmpty) ...[
            TypingIndicatorWidget(userCount: typingUsers.length),
            // Debug info
            if (true) // Set to false to hide debug
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Text(
                  'Debug: ${typingUsers.length} users typing: ${typingUsers.join(", ")}',
                  style: const TextStyle(fontSize: 10, color: Colors.red),
                ),
              ),
          ],

          // Message input
          MessageInput(
            controller: _textController,
            onChanged: _handleTextChanged,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  bool _shouldShowDateHeader(List<Message> messages, int index) {
    if (index == messages.length - 1) return true;

    final currentMessage = messages[index];
    final nextMessage = messages[index + 1];

    final currentDate = DateTime(
      currentMessage.createdAt.year,
      currentMessage.createdAt.month,
      currentMessage.createdAt.day,
    );
    final nextDate = DateTime(
      nextMessage.createdAt.year,
      nextMessage.createdAt.month,
      nextMessage.createdAt.day,
    );

    return currentDate != nextDate;
  }

  bool _shouldShowAvatar(
    List<Message> messages,
    int index,
    String conversationType,
  ) {
    // Always show avatar for the first message
    if (index == 0) return true;

    final currentMessage = messages[index];
    final previousMessage = messages[index - 1];

    // Show avatar when sender changes
    return currentMessage.senderId != previousMessage.senderId;
  }

  Future<void> _deleteMessage(int messageId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc chắn muốn xóa tin nhắn này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (!mounted) return;
      await context.read<ChatProvider>().deleteMessage(messageId);
      if (!mounted) return;
      await context.read<ChatProvider>().loadMessages(widget.conversation.id);
    }
  }
}

class _DateHeader extends StatelessWidget {
  final DateTime date;

  const _DateHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _formatDate(date),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Hôm nay';
    } else if (messageDate == yesterday) {
      return 'Hôm qua';
    } else if (now.difference(date).inDays < 7) {
      return DateFormat('EEEE', 'vi').format(date);
    } else if (date.year == now.year) {
      return DateFormat('d MMMM', 'vi').format(date);
    } else {
      return DateFormat('d MMMM, yyyy', 'vi').format(date);
    }
  }
}
