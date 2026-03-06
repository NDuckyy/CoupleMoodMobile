import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chat/user_search_result.dart';
import '../../services/chat/messaging_api_service.dart';
import '../../providers/chat/chat_provider.dart';
import 'chat_screen.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserSearchResult> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;
  bool _hasMore = false;
  int _currentPage = 1;
  String? _error;
  bool _isShowingDialog = false; // Track dialog state

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
        _error = null;
      });
    }
  }

  Future<void> _performSearch(String query, {bool loadMore = false}) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
      if (!loadMore) {
        _searchResults = [];
        _currentPage = 1;
      }
      _error = null;
    });

    try {
      final response = await MessagingApiService.searchUsers(
        query: query.trim(),
        page: loadMore ? _currentPage + 1 : 1,
        pageSize: 20,
      );

      if (!mounted) return;

      setState(() {
        if (loadMore) {
          _searchResults.addAll(response.data);
          _currentPage++;
        } else {
          _searchResults = response.data;
          _currentPage = 1;
        }
        _hasMore = response.pagination.hasMore;
        _hasSearched = true;
        _isSearching = false;
      });
    } catch (e) {
      print('Error searching users: $e');
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isSearching = false;
        _hasSearched = true;
      });
    }
  }

  Future<void> _onUserTap(UserSearchResult user) async {
    // Prevent multiple taps
    if (_isShowingDialog) return;
    
    setState(() {
      _isShowingDialog = true;
    });

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );

    try {
      final chatProvider = context.read<ChatProvider>();
      final conversation = await chatProvider.getOrCreateDirectConversation(user.userId);

      // Close loading dialog
      if (mounted && _isShowingDialog) {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          _isShowingDialog = false;
        });
      }

      if (!mounted) return;

      if (conversation != null) {
        // Navigate to chat screen
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(conversation: conversation),
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(chatProvider.error ?? 'Failed to create conversation'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog
      if (mounted && _isShowingDialog) {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          _isShowingDialog = false;
        });
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (query) {
                if (query.trim().isNotEmpty) {
                  _performSearch(query);
                }
              },
            ),
          ),

          // Results
          Expanded(
            child: _isSearching && _searchResults.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
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
                            ElevatedButton(
                              onPressed: () {
                                final query = _searchController.text.trim();
                                if (query.isNotEmpty) {
                                  _performSearch(query);
                                }
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : !_hasSearched
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Search for users to start a conversation',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : _searchResults.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_off,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No users found',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: _searchResults.length + (_hasMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == _searchResults.length) {
                                    // Load more indicator
                                    return Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: _isSearching
                                          ? const Center(child: CircularProgressIndicator())
                                          : TextButton(
                                              onPressed: () {
                                                final query = _searchController.text.trim();
                                                if (query.isNotEmpty) {
                                                  _performSearch(query, loadMore: true);
                                                }
                                              },
                                              child: const Text('Load More'),
                                            ),
                                    );
                                  }

                                  final user = _searchResults[index];
                                  return _UserTile(
                                    user: user,
                                    onTap: () => _onUserTap(user),
                                  );
                                },
                              ),
          ),
        ],
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final UserSearchResult user;
  final VoidCallback onTap;

  const _UserTile({
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
            ? NetworkImage(user.avatarUrl!)
            : null,
        child: user.avatarUrl == null || user.avatarUrl!.isEmpty
            ? Text(
                user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            : null,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              user.fullName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (user.relationshipStatus == 'IN_RELATIONSHIP')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite, size: 12, color: Colors.pink[300]),
                  const SizedBox(width: 4),
                  Text(
                    'In Relationship',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.pink[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      subtitle: user.bio != null && user.bio!.isNotEmpty
          ? Text(
              user.bio!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: const Icon(Icons.chat_bubble_outline),
    );
  }
}
