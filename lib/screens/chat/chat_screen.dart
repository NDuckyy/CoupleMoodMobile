import 'dart:async';
import 'package:couple_mood_mobile/providers/date_plan_provider.dart';
import 'package:couple_mood_mobile/screens/chat/widgets/group_avatar.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
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
  late ChatProvider chatProvider;
  StreamSubscription? _conversationSub;
  final Set<int> _deletedMessageIds = {};

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatProvider>();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
    _scrollController.addListener(_onScroll);
    _listenRealtimeUpdates();
  }

  Future<void> _initialize() async {
    // Join conversation room
    await chatProvider.joinConversation(widget.conversation.id);
    if (!mounted) return;
    // Load messages
    await chatProvider.loadMessages(widget.conversation.id);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messages = chatProvider.getMessages(widget.conversation.id);
      _autoDeleteDraftedMessages(messages);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreMessages();
    }
  }

  Future<void> _loadMoreMessages() async {
    if (_isLoadingMore) return;

    if (!chatProvider.hasMoreMessages(widget.conversation.id)) return;

    setState(() => _isLoadingMore = true);
    await chatProvider.loadMessages(widget.conversation.id, loadMore: true);
    setState(() => _isLoadingMore = false);
  }

  void _handleTextChanged(String text) {
    _typingTimer?.cancel();

    if (text.isNotEmpty) {
      if (!_isTyping) {
        _isTyping = true;
        chatProvider.sendTypingIndicator(widget.conversation.id, true);
      }

      _typingTimer = Timer(const Duration(seconds: 2), () {
        _isTyping = false;
        chatProvider.sendTypingIndicator(widget.conversation.id, false);
      });
    } else {
      if (_isTyping) {
        _isTyping = false;
        chatProvider.sendTypingIndicator(widget.conversation.id, false);
      }
    }
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    // Stop typing indicator
    if (_isTyping) {
      _isTyping = false;
      _typingTimer?.cancel();
      chatProvider.sendTypingIndicator(widget.conversation.id, false);
    }

    // Clear input
    _textController.clear();

    // Send message
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
    if (state == AppLifecycleState.paused) {
      // App going to background
      chatProvider.leaveConversation(widget.conversation.id);
    } else if (state == AppLifecycleState.resumed) {
      // App coming to foreground
      chatProvider.joinConversation(widget.conversation.id);
    }
  }

  void _onAcceptDatePlan(int datePlanId) async {
    final datePlanProvider = context.read<DatePlanProvider>();
    await datePlanProvider.acceptDatePlan(datePlanId);
    if (datePlanProvider.error != null) {
      if (!mounted) return;
      showMsg(context, datePlanProvider.error!, false);
    } else {
      if (!mounted) return;
      showMsg(context, 'Bạn đã chấp nhận lịch hẹn', true);
      // Optionally refresh messages or date plan status
      await chatProvider.loadMessages(widget.conversation.id);
    }
  }

  void _onRejectDatePlan(int datePlanId, int messageId) async {
    final datePlanProvider = context.read<DatePlanProvider>();
    await datePlanProvider.rejectDatePlan(datePlanId);
    if (datePlanProvider.error != null) {
      if (!mounted) return;
      showMsg(context, datePlanProvider.error!, false);
    } else {
      if (!mounted) return;
      showMsg(context, 'Bạn đã từ chối lịch hẹn', true);

      await chatProvider.deleteMessage(messageId);
      await chatProvider.loadMessages(widget.conversation.id);
    }
  }

  void _listenRealtimeUpdates() {
    _conversationSub = chatProvider.signalR.onConversationUpdated.listen((
      conversation,
    ) {
      if (conversation.id == widget.conversation.id) {
        chatProvider.loadMessages(widget.conversation.id);
        final messages = chatProvider.getMessages(widget.conversation.id);
        _autoDeleteDraftedMessages(messages);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _textController.dispose();
    _typingTimer?.cancel();
    _conversationSub?.cancel();
    // Leave conversation
    chatProvider.leaveConversation(widget.conversation.id);

    super.dispose();
  }

  void _autoDeleteDraftedMessages(List<Message> messages) async {
    for (var msg in messages) {
      if (msg.messageType == 'DATE_PLAN' &&
          msg.datePlanInfo?['status'] == 'DRAFTED') {
        if (!_deletedMessageIds.contains(msg.id)) {
          _deletedMessageIds.add(msg.id);

          unawaited(chatProvider.deleteMessage(msg.id));
        }
      }
    }
  }

  List<Message> _filterDraftedMessages(List<Message> rawMessages) {
    return rawMessages.where((msg) {
      if (msg.messageType == 'DATE_PLAN' &&
          msg.datePlanInfo?['status']?.toString() == 'DRAFTED') {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final displayName = widget.conversation.getDisplayName();
    final isOnline = widget.conversation.getOnlineStatus();
    final rawMessages = chatProvider.getMessages(widget.conversation.id);
    final messages = _filterDraftedMessages(rawMessages);
    final isLoading = chatProvider.isLoadingMessages(widget.conversation.id);
    final typingUsers = chatProvider.getTypingUsers(widget.conversation.id);

    // Debug log
    if (typingUsers.isNotEmpty) {
      print(
        'ChatScreen: Typing users updated - ${typingUsers.length} users: $typingUsers',
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0FF),
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
              widget.conversation.getDisplayAvatar() != null
                  ? CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(
                        widget.conversation.getDisplayAvatar()!,
                      ),
                      backgroundColor: Colors.transparent,
                    )
                  : widget.conversation.type == 'GROUP'
                  ? SizedBox(
                      width: 36,
                      height: 36,
                      child: GroupAvatar(
                        members: widget.conversation.members,
                        size: 36,
                      ),
                    )
                  : CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFFFDC5F5),
                      child: Text(
                        displayName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                            onAccept: (datePlanId) =>
                                _onAcceptDatePlan(datePlanId),
                            onReject: (datePlanId) =>
                                _onRejectDatePlan(datePlanId, message.id),
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
            if (false) // Set to false to hide debug
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
            conversationId: widget.conversation.id,
          ),
        ],
      ),
    );
  }

  bool _shouldShowDateHeader(List<Message> messages, int index) {
    if (index == messages.length - 1) return true;

    final currentMessage = messages[index];
    final nextMessage = messages[index + 1];

    final currentDateTime = currentMessage.createdAt.toLocal();
    final nextDateTime = nextMessage.createdAt.toLocal();

    final currentDate = DateTime(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
    );
    final nextDate = DateTime(
      nextDateTime.year,
      nextDateTime.month,
      nextDateTime.day,
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
      await chatProvider.deleteMessage(messageId);
      if (!mounted) return;
      await chatProvider.loadMessages(widget.conversation.id);
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
    final localDate = date.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(
      localDate.year,
      localDate.month,
      localDate.day,
    );

    if (messageDate == today) {
      return 'Hôm nay';
    } else if (messageDate == yesterday) {
      return 'Hôm qua';
    } else if (now.difference(localDate).inDays < 7) {
      return DateFormat('EEEE', 'vi').format(localDate);
    } else if (localDate.year == now.year) {
      return DateFormat('d MMMM', 'vi').format(localDate);
    } else {
      return DateFormat('d MMMM, yyyy', 'vi').format(localDate);
    }
  }
}
