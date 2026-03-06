import 'package:couple_mood_mobile/providers/post/post_provider.dart';
import 'package:couple_mood_mobile/screens/feed/create_edit_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/post/my_posts_provider.dart';
import '../../widgets/feed/create_post_box.dart';
import '../../widgets/feed/post_card.dart';
import '../../widgets/feed/profile_summary.dart';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({super.key});

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<MyPostsProvider>().loadMyPosts();
    });

    _scrollController.addListener(() {
      final provider = context.read<MyPostsProvider>();

      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 300) {
        provider.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MyPostsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile"), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: provider.refresh,
        child: provider.loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount:
                    provider.posts.length + 2 + (provider.loadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  /// Profile Summary
                  if (index == 0) {
                    return const ProfileSummary();
                  }

                  ///  Create Post
                  if (index == 1) {
                    return CreatePostBox(
                      onTap: () async {
                        final created = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateEditPostScreen(),
                          ),
                        );

                        if (created == true) {
                          context.read<PostProvider>().loadFeeds();
                        }
                      },
                    );
                  }

                  final postIndex = index - 2;

                  /// loading more
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
