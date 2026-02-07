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

class ChatScreen extends StatefulWidget {
  final Conversation conversation;

  const ChatScreen({
    super.key,
    required this.conversation,
  });

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
      chatProvider.sendTypingIndicator(widget.conversation.id, true);
      
      // Auto-stop typing after 3 seconds
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 3), () {
        _isTyping = false;
        chatProvider.sendTypingIndicator(widget.conversation.id, false);
      });
    } else if (text.isEmpty && _isTyping) {
      _isTyping = false;
      _typingTimer?.cancel();
      chatProvider.sendTypingIndicator(widget.conversation.id, false);
    }
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    // Stop typing indicator
    if (_isTyping) {
      _isTyping = false;
      _typingTimer?.cancel();
      context.read<ChatProvider>().sendTypingIndicator(widget.conversation.id, false);
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
    final displayName = widget.conversation.getDisplayName(currentUserId);
    final isOnline = widget.conversation.getOnlineStatus(currentUserId);
    final messages = chatProvider.getMessages(widget.conversation.id);
    final isLoading = chatProvider.isLoadingMessages(widget.conversation.id);
    final typingUsers = chatProvider.getTypingUsers(widget.conversation.id);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[300],
              backgroundImage: widget.conversation.getDisplayAvatar(currentUserId) != null
                  ? NetworkImage(widget.conversation.getDisplayAvatar(currentUserId)!)
                  : null,
              child: widget.conversation.getDisplayAvatar(currentUserId) == null
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show menu
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
                              'No messages yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Send a message to start the conversation',
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
          if (typingUsers.isNotEmpty)
            TypingIndicatorWidget(
              userCount: typingUsers.length,
            ),

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

  bool _shouldShowAvatar(List<Message> messages, int index, String conversationType) {
    if (conversationType == 'DIRECT') return false;
    if (index == 0) return true;

    final currentMessage = messages[index];
    final previousMessage = messages[index - 1];

    return currentMessage.senderId != previousMessage.senderId;
  }

  Future<void> _deleteMessage(int messageId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await context.read<ChatProvider>().deleteMessage(messageId);
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
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else if (now.difference(date).inDays < 7) {
      return DateFormat('EEEE').format(date);
    } else if (date.year == now.year) {
      return DateFormat('MMMM d').format(date);
    } else {
      return DateFormat('MMMM d, yyyy').format(date);
    }
  }
}
