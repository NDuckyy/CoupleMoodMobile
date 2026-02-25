import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/chat/chat_provider.dart';
import '../../models/chat/conversation.dart';
import 'chat_screen.dart';
import 'user_search_screen.dart';
import 'new_conversation_dialog.dart';
import 'create_group_screen.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().initialize();
    });
  }

  Future<void> _showNewConversationDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const NewConversationDialog(),
    );

    if (!mounted) return;

    if (result == 'direct') {
      // Navigate to user search
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UserSearchScreen(),
        ),
      );
    } else if (result == 'group') {
      // Navigate to create group
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateGroupScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserSearchScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showNewConversationDialog,
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.isLoadingConversations) {
            return const Center(child: CircularProgressIndicator());
          }

          if (chatProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${chatProvider.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => chatProvider.loadConversations(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (chatProvider.conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No conversations yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start a new conversation',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => chatProvider.loadConversations(),
            child: Column(
              children: [
                // Connection status indicator
                if (!chatProvider.isConnected)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    color: Colors.orange,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_off, size: 16, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Connecting...',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                
                // Conversation list
                Expanded(
                  child: ListView.builder(
                    itemCount: chatProvider.conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = chatProvider.conversations[index];
                      final currentUserId = chatProvider.currentUserId ?? 0;
                      
                      if (currentUserId == 0) {
                        print('WARNING: currentUserId is 0!');
                      }
                      
                      return _ConversationItem(
                        conversation: conversation,
                        currentUserId: currentUserId,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                conversation: conversation,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ConversationItem extends StatelessWidget {
  final Conversation conversation;
  final int currentUserId;
  final VoidCallback onTap;

  const _ConversationItem({
    required this.conversation,
    required this.currentUserId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = conversation.getDisplayName();
    final displayAvatar = conversation.getDisplayAvatar();
    final isOnline = conversation.getOnlineStatus();
    final lastMessage = conversation.lastMessage;
    final unreadCount = conversation.unreadCount;

    print('ConversationItem - conversationId: ${conversation.id}, currentUserId: $currentUserId, displayName: $displayName');

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: displayAvatar != null
                      ? NetworkImage(displayAvatar)
                      : null,
                  onBackgroundImageError: displayAvatar != null
                      ? (exception, stackTrace) {
                          print('Error loading avatar: $exception');
                        }
                      : null,
                  child: displayAvatar == null
                      ? conversation.type == 'GROUP'
                          ? const Icon(Icons.group, size: 28)
                          : Text(
                              displayName[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                      : null,
                ),
                // Online indicator
                if (isOnline && conversation.type == 'DIRECT')
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          displayName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: unreadCount > 0
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (lastMessage != null)
                        Text(
                          _formatTimestamp(lastMessage.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: unreadCount > 0
                                ? Theme.of(context).primaryColor
                                : Colors.grey[600],
                            fontWeight: unreadCount > 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage?.content ?? 'No messages yet',
                          style: TextStyle(
                            fontSize: 14,
                            color: unreadCount > 0
                                ? Colors.black87
                                : Colors.grey[600],
                            fontWeight: unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            unreadCount > 99 ? '99+' : unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return DateFormat('EEE').format(timestamp);
    } else if (difference.inDays < 365) {
      return DateFormat('MMM d').format(timestamp);
    } else {
      return DateFormat('M/d/yy').format(timestamp);
    }
  }
}
