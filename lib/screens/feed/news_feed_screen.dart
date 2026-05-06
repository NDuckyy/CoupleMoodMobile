import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_mood_mobile/screens/feed/create_edit_post_screen.dart';
import 'package:couple_mood_mobile/widgets/feed/create_post_box.dart';
import 'package:couple_mood_mobile/widgets/feed/post_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 600) {
      // tăng khoảng cách preload
      context.read<PostProvider>().loadMore();
    }
  }

  // Precache một vài ảnh đầu tiên để mượt hơn khi mở màn hình
  Future<void> _precacheFirstPosts() async {
    final provider = context.read<PostProvider>();
    if (provider.posts.isEmpty) return;

    // Chỉ precache 3-4 bài đầu tiên (avatar + media)
    for (int i = 0; i < provider.posts.length && i < 4; i++) {
      final post = provider.posts[i];

      // Avatar + Frame + Badge
      if (post.author?.avatar != null) {
        precacheImage(
          CachedNetworkImageProvider(post.author!.avatar!),
          context,
        );
      }

      // Media images
      for (final media in post.mediaPayload.take(2)) {
        // chỉ lấy 1-2 ảnh đầu
        precacheImage(CachedNetworkImageProvider(media.url), context);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Gọi sau khi build lần đầu để có context
    Future.microtask(_precacheFirstPosts);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostProvider>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 248, 255),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
            } else {
              context.goNamed('home');
            }
          },
        ),
        title: const Text("Bảng tin"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await provider.loadFeeds();
          await _precacheFirstPosts(); // precache lại sau refresh
        },
        child: provider.loading
            ? ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 2),
                itemCount: 5,
                itemBuilder: (_, __) => const PostCardSkeleton(),
              )
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 2),
                // Tăng cacheExtent để preload nhiều item hơn (mặc định ~250px)
                cacheExtent:
                    1200, // ← Quan trọng: preload khoảng 3-5 bài tiếp theo
                itemCount:
                    provider.posts.length +
                    1 + // Create Post Box
                    (provider.loadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return CreatePostBox(
                      onTap: () async {
                        final created = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateEditPostScreen(),
                          ),
                        );
                        if (created == true) {
                          provider.loadFeeds();
                        }
                      },
                      onAvatarTap: () => context.pushNamed("my_posts"),
                    );
                  }

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
