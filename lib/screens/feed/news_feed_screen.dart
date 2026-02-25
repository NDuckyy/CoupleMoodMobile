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
                    provider.posts.length + (provider.loadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == provider.posts.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final post = provider.posts[index];

                  return PostCard(post: post);
                },
              ),
      ),
    );
  }
}
