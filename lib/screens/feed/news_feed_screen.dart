import 'package:couple_mood_mobile/screens/feed/create_edit_post_screen.dart';
import 'package:couple_mood_mobile/widgets/feed/create_post_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/post/post_provider.dart';
import '../../widgets/feed/post_card.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final provider = context.read<PostProvider>();
    provider.loadFeeds();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 300) {
        provider.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("News Feed"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.loadFeeds(),
        child: provider.loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount:
                    provider.posts.length + 1 + (provider.loadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  /// Create Post Box
                  if (index == 0) {
                    return CreatePostBox(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateEditPostScreen(),
                          ),
                        );
                      },
                    );
                  }

                  /// Post item
                  final postIndex = index - 1;

                  if (postIndex == provider.posts.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final post = provider.posts[postIndex];

                  return PostCard(post: post);
                },
              ),
      ),
    );
  }
}
