import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat/chat_provider.dart';
import '../../models/chat/user_search_result.dart';
import '../../services/chat/messaging_api_service.dart';
import 'chat_screen.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final List<UserSearchResult> _selectedMembers = [];
  final List<UserSearchResult> _searchResults = [];
  bool _isSearching = false;
  bool _isCreating = false;
  String? _error;

  @override
  void dispose() {
    _groupNameController.dispose();
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
        _searchResults.addAll(response.data);
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isSearching = false;
      });
    }
  }

  void _addMember(UserSearchResult user) {
    if (_selectedMembers.any((m) => m.userId == user.userId)) {
      showMsg(context, "User already added ", false);
      return;
    }

    setState(() {
      _selectedMembers.add(user);
      _searchController.clear();
      _searchResults.clear();
    });
  }

  void _removeMember(UserSearchResult user) {
    setState(() {
      _selectedMembers.removeWhere((m) => m.userId == user.userId);
    });
  }

  Future<void> _createGroup() async {
    final groupName = _groupNameController.text.trim();

    if (groupName.isEmpty) {
      showMsg(context, "Please enter a group name", false);
      return;
    }

    if (_selectedMembers.isEmpty) {
      showMsg(context, "Please add at least a member", false);
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      final chatProvider = context.read<ChatProvider>();
      final memberIds = _selectedMembers.map((m) => m.userId).toList();

      final conversation = await chatProvider.createGroupConversation(
        name: groupName,
        memberIds: memberIds,
      );

      if (!mounted) return;

      if (conversation != null) {
        // Navigate to the new group chat
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(conversation: conversation),
          ),
        );
      } else {
        setState(() {
          _isCreating = false;
        });
        showMsg(context, "Failed to create group", false);
      }
    } catch (e) {
      setState(() {
        _isCreating = false;
      });
      showMsg(context, e.toString(), false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canCreate =
        _groupNameController.text.trim().isNotEmpty &&
        _selectedMembers.isNotEmpty &&
        !_isCreating;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: canCreate ? _createGroup : null,
            child: _isCreating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Create',
                    style: TextStyle(
                      color: canCreate ? Colors.white : Colors.white54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Group name input
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _groupNameController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Group Name',
                hintText: 'Enter group name',
                prefixIcon: const Icon(Icons.group),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLength: 100,
            ),
          ),

          const Divider(height: 1),

          // Selected members
          if (_selectedMembers.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Members (${_selectedMembers.length})',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedMembers.map((member) {
                      return Chip(
                        avatar: CircleAvatar(
                          backgroundImage:
                              member.avatarUrl != null &&
                                  member.avatarUrl!.isNotEmpty
                              ? NetworkImage(member.avatarUrl!)
                              : null,
                          onBackgroundImageError:
                              member.avatarUrl != null &&
                                  member.avatarUrl!.isNotEmpty
                              ? (exception, stackTrace) {
                                  print(
                                    'Error loading chip avatar: $exception',
                                  );
                                }
                              : null,
                          child:
                              member.avatarUrl == null ||
                                  member.avatarUrl!.isEmpty
                              ? Text(member.fullName[0].toUpperCase())
                              : null,
                        ),
                        label: Text(member.fullName),
                        onDeleted: () => _removeMember(member),
                        deleteIcon: const Icon(Icons.close, size: 18),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
          ],

          // Search members
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: _searchUsers,
              decoration: InputDecoration(
                hintText: 'Search users to add...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults.clear();
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Search results
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: $_error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                final query = _searchController.text.trim();
                if (query.isNotEmpty) {
                  _searchUsers(query);
                }
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty && _searchController.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Search for users to add',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No users found',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        final isAdded = _selectedMembers.any((m) => m.userId == user.userId);

        return ListTile(
          leading: CircleAvatar(
            backgroundImage:
                user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                ? NetworkImage(user.avatarUrl!)
                : null,
            onBackgroundImageError:
                user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                ? (exception, stackTrace) {
                    print('Error loading search result avatar: $exception');
                  }
                : null,
            child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                ? Text(user.fullName[0].toUpperCase())
                : null,
          ),
          title: Text(user.fullName),
          subtitle: user.bio != null ? Text(user.bio!, maxLines: 1) : null,
          trailing: isAdded
              ? const Icon(Icons.check_circle, color: Colors.green)
              : const Icon(Icons.add_circle_outline),
          onTap: isAdded ? null : () => _addMember(user),
        );
      },
    );
  }
}
