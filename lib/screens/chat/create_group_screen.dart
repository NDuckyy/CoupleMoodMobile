import 'package:couple_mood_mobile/screens/coupleInvitation/widget/search_member/search_bar.dart';
import 'package:couple_mood_mobile/widgets/empty_widget.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/chat/chat_provider.dart';
import '../../models/chat/user_search_result.dart';
import '../../services/chat/messaging_api_service.dart';

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
      showMsg(context, "Người này đã được thêm vào", false);
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
        context.pop();
      } else {
        setState(() {
          _isCreating = false;
        });
        showMsg(context, "Không thể tạo group chat bây giờ", false);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Tạo nhóm trò chuyện'),
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
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  )
                : Text(
                    'Tạo nhóm',
                    style: TextStyle(
                      color: canCreate ? Colors.black : Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group name input
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFDC5F5), Color(0xFFF7AEF8)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB388EB).withOpacity(0.25),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _groupNameController,
                  onChanged: (_) => setState(() {}),
                  cursorColor: const Color(0xFFB388EB),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.group, color: Color(0xFF8093F1)),
                    hintText: "Nhập tên nhóm 💕",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                    counterText: "",
                  ),
                  maxLength: 100,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Selected members

          // Search members
          Container(
            color: Colors.white,
            child: UserSearchBar(
              controller: _searchController,
              onSearch: (value) {
                _searchUsers(value);
              },
            ),
          ),
          const SizedBox(height: 12),

          if (_selectedMembers.isNotEmpty) ...[
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thành viên (${_selectedMembers.length})',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _selectedMembers.map((member) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Chip(
                            backgroundColor: Color(0xFF8093F1),
                            side: BorderSide(color: Color(0xFF8093F1), width: 1),
                            avatar: CircleAvatar(
                              radius: 12,
                              backgroundImage:
                                  member.avatarUrl != null &&
                                      member.avatarUrl!.isNotEmpty
                                  ? NetworkImage(member.avatarUrl!)
                                  : null,
                              child:
                                  member.avatarUrl == null ||
                                      member.avatarUrl!.isEmpty
                                  ? Text(
                                      member.fullName[0].toUpperCase(),
                                      style: const TextStyle(fontSize: 12),
                                    )
                                  : null,
                            ),
                            label: Text(
                              member.fullName,
                              style: const TextStyle(fontSize: 13, color: Colors.white),
                            ),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () => _removeMember(member),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
              'Lỗi: $_error',
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
              label: const Text('Thử lại'),
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
              'Tìm kiếm bạn bè để thêm vào nhóm',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: EmptyStateWidget(
              icon: Icons.person_off,
              title: "Không tìm thấy người dùng",
              description: "Hãy thử tên người dùng khác",
            ),
          ),
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
