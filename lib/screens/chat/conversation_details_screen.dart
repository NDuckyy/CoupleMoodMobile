import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/chat/conversation.dart';
import '../../models/chat/conversation_member.dart';
import '../../providers/chat/chat_provider.dart';
import '../../models/chat/user_search_result.dart';
import '../../services/chat/messaging_api_service.dart';

class ConversationDetailsScreen extends StatefulWidget {
  final Conversation conversation;

  const ConversationDetailsScreen({
    super.key,
    required this.conversation,
  });

  @override
  State<ConversationDetailsScreen> createState() => _ConversationDetailsScreenState();
}

class _ConversationDetailsScreenState extends State<ConversationDetailsScreen> {
  late Conversation _conversation;

  @override
  void initState() {
    super.initState();
    _conversation = widget.conversation;
  }

  Future<void> _showAddMembersDialog() async {
    final result = await showDialog<List<UserSearchResult>>(
      context: context,
      builder: (context) => _AddMembersDialog(
        existingMemberIds: _conversation.members.map((m) => m.userId).toList(),
      ),
    );

    if (result != null && result.isNotEmpty) {
      _addMembers(result);
    }
  }

  Future<void> _addMembers(List<UserSearchResult> users) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final chatProvider = context.read<ChatProvider>();
    
    // Add all members at once
    final memberIds = users.map((u) => u.userId).toList();
    final success = await chatProvider.addMembersToGroup(
      _conversation.id,
      memberIds,
    );

    if (!mounted) return;
    Navigator.pop(context); // Close loading

    if (success) {
      // Reload conversations to get updated member list
      await chatProvider.loadConversations();
      
      // Find updated conversation
      final updated = chatProvider.conversations.firstWhere(
        (c) => c.id == _conversation.id,
        orElse: () => _conversation,
      );
      
      setState(() {
        _conversation = updated;
      });
      
      showMsg(context, "Thêm thành viên thành công", true);
    } else {
      showMsg(context, "Lỗi khi thêm thành viên", false);
    }
  }

  Future<void> _removeMember(ConversationMember member) async {
    final currentUserId = context.read<ChatProvider>().currentUserId;
    
    if (member.userId == currentUserId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Use "Leave Group" to remove yourself'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa thành viên'),
        content: Text('Bạn có chắc muốn xóa ${member.fullName ?? "User"} ra khỏi nhóm không ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final chatProvider = context.read<ChatProvider>();
    final success = await chatProvider.removeMemberFromGroup(
      _conversation.id,
      member.userId,
    );

    if (!mounted) return;
    Navigator.pop(context); // Close loading

    if (success) {
      setState(() {
        _conversation = _conversation.copyWith(
          members: _conversation.members.where((m) => m.userId != member.userId).toList(),
        );
      });
      
      showMsg(context, "Xóa thành viên thành công", true);
    } else {
      showMsg(context, "Lỗi khi xóa thành viên", false);
    }
  }

  Future<void> _leaveGroup() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rời nhóm'),
        content: const Text('Bạn có chắc muốn rời khỏi nhóm này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Rời nhóm',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final chatProvider = context.read<ChatProvider>();
    final currentUserId = chatProvider.currentUserId;
    if (currentUserId == null) return;
    
    final success = await chatProvider.removeMemberFromGroup(
      _conversation.id,
      currentUserId,
    );
    await chatProvider.loadConversations();

    if (!mounted) return;
    context.pop(); // Close loading

    if (success) {
      // Navigate back to conversation list
      Navigator.popUntil(context, (route) => route.isFirst);
      
      showMsg(context, "Bạn đã rời khỏi nhóm", true);
    } else {
      showMsg(context, "Lỗi khi rời khỏi nhóm", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.watch<ChatProvider>().currentUserId ?? '';
    final isGroup = _conversation.type == 'GROUP';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Thông tin cuộc trò chuyện'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Conversation info
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.white,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _conversation.getDisplayAvatar() != null
                      ? NetworkImage(_conversation.getDisplayAvatar()!)
                      : null,
                  onBackgroundImageError: _conversation.getDisplayAvatar() != null
                      ? (exception, stackTrace) {
                          print('Error loading conversation avatar: $exception');
                        }
                      : null,
                  child: _conversation.getDisplayAvatar() == null
                      ? Icon(
                          isGroup ? Icons.group : Icons.person,
                          size: 50,
                          color: Colors.grey[600],
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  _conversation.getDisplayName(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (isGroup) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${_conversation.members.length} thành viên',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Divider(height: 1),

          // Members section (for groups)
          if (isGroup) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Thành viên',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _showAddMembersDialog,
                    icon: const Icon(Icons.person_add),
                    label: const Text('Thêm thành viên'),
                  ),
                ],
              ),
            ),
            
            // Member list
            ..._conversation.members.map((member) {
              final isSelf = member.userId == currentUserId;
              return ListTile(
                leading: Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: member.avatar != null && member.avatar!.isNotEmpty
                          ? NetworkImage(member.avatar!)
                          : null,
                      onBackgroundImageError: member.avatar != null && member.avatar!.isNotEmpty
                          ? (exception, stackTrace) {
                              print('Error loading member avatar: $exception');
                            }
                          : null,
                      child: member.avatar == null || member.avatar!.isEmpty
                          ? Text((member.fullName ?? 'U')[0].toUpperCase())
                          : null,
                    ),
                    if (member.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(
                  isSelf ? '${member.fullName ?? "User"} (Bạn)' : (member.fullName ?? "User ${member.userId}"),
                  style: TextStyle(
                    fontWeight: isSelf ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: member.joinedAt != null && !member.isOnline
                    ? Text('Lần cuối đăng nhập: ${_formatLastSeen(member.joinedAt!)}')
                    : null,
                trailing: !isSelf
                    ? IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        onPressed: () => _removeMember(member),
                      )
                    : null,
              );
            }).toList(),

            const Divider(height: 1),

            // Leave group button
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text(
                'Rời nhóm',
                style: TextStyle(color: Colors.red),
              ),
              onTap: _leaveGroup,
            ),
          ],
        ],
      ),
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);
    
    if (difference.inMinutes < 1) {
      return 'Truy cập gần đây';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} tiếng trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${lastSeen.day}/${lastSeen.month}/${lastSeen.year}';
    }
  }
}

// Dialog for adding members
class _AddMembersDialog extends StatefulWidget {
  final List<int> existingMemberIds;

  const _AddMembersDialog({
    required this.existingMemberIds,
  });

  @override
  State<_AddMembersDialog> createState() => _AddMembersDialogState();
}

class _AddMembersDialogState extends State<_AddMembersDialog> {
  final TextEditingController _searchController = TextEditingController();
  final List<UserSearchResult> _selectedUsers = [];
  final List<UserSearchResult> _searchResults = [];
  bool _isSearching = false;
  String? _error;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
    });

    try {
      final response = await MessagingApiService.searchUsers(
        query: query.trim(),
        page: 1,
        pageSize: 20,
      );

      setState(() {
        _searchResults.clear();
        _searchResults.addAll(
          response.data.where((user) => !widget.existingMemberIds.contains(user.userId)),
        );
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isSearching = false;
      });
    }
  }

  void _toggleUser(UserSearchResult user) {
    setState(() {
      if (_selectedUsers.any((u) => u.userId == user.userId)) {
        _selectedUsers.removeWhere((u) => u.userId == user.userId);
      } else {
        _selectedUsers.add(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Thêm thành viên ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search bar
            TextField(
              controller: _searchController,
              onChanged: _searchUsers,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm bạn bè',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Selected users
            if (_selectedUsers.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                children: _selectedUsers.map((user) {
                  return Chip(
                    label: Text(user.fullName),
                    onDeleted: () => _toggleUser(user),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Search results
            Expanded(
              child: _buildSearchResults(),
            ),

            // Add button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedUsers.isEmpty
                    ? null
                    : () => Navigator.pop(context, _selectedUsers),
                child: Text('Thêm ${_selectedUsers.length} thành viên'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text('Error: $_error', style: const TextStyle(color: Colors.red)));
    }

    if (_searchResults.isEmpty && _searchController.text.isEmpty) {
      return const Center(child: Text('Tìm kiếm bạn bè để thêm vào nhóm'));
    }

    if (_searchResults.isEmpty) {
      return const Center(child: Text('Không tìm thấy người bạn muốn tìm'));
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        final isSelected = _selectedUsers.any((u) => u.userId == user.userId);

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                ? NetworkImage(user.avatarUrl!)
                : null,
            onBackgroundImageError: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                ? (exception, stackTrace) {
                    print('Error loading add member avatar: $exception');
                  }
                : null,
            child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                ? Text(user.fullName[0].toUpperCase())
                : null,
          ),
          title: Text(user.fullName),
          subtitle: user.bio != null ? Text(user.bio!, maxLines: 1) : null,
          trailing: Checkbox(
            value: isSelected,
            onChanged: (_) => _toggleUser(user),
          ),
          onTap: () => _toggleUser(user),
        );
      },
    );
  }
}
