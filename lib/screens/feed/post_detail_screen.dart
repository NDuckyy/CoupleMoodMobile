import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/post/post_detail_provider.dart';
import '../../widgets/feed/post_media.dart';
import '../../widgets/feed/hashtag_wrap.dart';
import '../../widgets/feed/comment_item.dart';

class PostDetailScreen extends StatefulWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();

  int? _replyingToCommentId;
  String? _replyingToName;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostDetailProvider>().init(widget.postId);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 200) {
        context.read<PostDetailProvider>().loadComments(widget.postId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostDetailProvider>();

    if (provider.loading || provider.post == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final post = provider.post!;

    return Scaffold(
      appBar: AppBar(title: const Text("Chi tiết bài viết")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: post.author.avatar != null
                          ? NetworkImage(post.author.avatar!)
                          : null,
                      child: post.author.avatar == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.author.fullName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _timeAgo(post.createdAt),
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

                const SizedBox(height: 12),

                /// FULL CONTENT
                Text(post.content),

                const SizedBox(height: 12),

                if (post.mediaPayload.isNotEmpty)
                  PostMedia(mediaList: post.mediaPayload),

                if (post.hashTags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  HashTagWrap(tags: post.hashTags),
                ],

                const SizedBox(height: 20),

                const Text(
                  "Bình luận",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Column(
                  children: provider.comments.map((c) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///  Level 1
                        CommentItem(
                          comment: c,
                          onReply: () {
                            setState(() {
                              _replyingToCommentId = c.id;
                              _replyingToName = c.author.fullName;
                            });
                          },
                          showViewReplies: c.replyCount > 0,
                          isExpanded: provider.isExpanded(c.id),
                          loadingReplies: provider.isLoadingReplies(c.id),
                          onViewReplies: () => provider.loadReplies(c),
                          onLike: () => provider.toggleLikeComment(c),
                        ),

                        ///  Level 2
                        ...provider.getReplies(c.id).map((reply) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommentItem(
                                comment: reply,
                                onReply: () {
                                  setState(() {
                                    _replyingToCommentId = reply.id;
                                    _replyingToName = c.author.fullName;
                                  });
                                },
                                showViewReplies: reply.replyCount > 0,
                                isExpanded: provider.isExpanded(reply.id),
                                loadingReplies: provider.isLoadingReplies(
                                  reply.id,
                                ),
                                onViewReplies: () =>
                                    provider.loadReplies(reply),
                                onLike: () => provider.toggleLikeComment(reply),
                              ),

                              ///  Level 3
                              ...provider
                                  .getReplies(reply.id)
                                  .map(
                                    (lv3) => CommentItem(
                                      comment: lv3,
                                      onReply: () {
                                        setState(() {
                                          _replyingToCommentId = lv3.id;
                                          _replyingToName = lv3.author.fullName;
                                        });
                                      },
                                      onLike: () =>
                                          provider.toggleLikeComment(lv3),
                                    ),
                                  ),
                            ],
                          );
                        }),
                      ],
                    );
                  }).toList(),
                ),

                if (provider.loadingComments)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),

          /// COMMENT INPUT
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_replyingToCommentId != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Đang trả lời $_replyingToName",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _replyingToCommentId = null;
                              _replyingToName = null;
                            });
                          },
                          child: const Icon(Icons.close, size: 16),
                        ),
                      ],
                    ),
                  ),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Viết bình luận...",
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        if (_controller.text.trim().isEmpty) return;

                        await provider.createComment(
                          content: _controller.text.trim(),
                          parentId: _replyingToCommentId,
                        );

                        _controller.clear();

                        setState(() {
                          _replyingToCommentId = null;
                          _replyingToName = null;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _timeAgo(DateTime dateTime) {
  final difference = DateTime.now().difference(dateTime);

  if (difference.inMinutes < 1) return "Vừa xong";
  if (difference.inMinutes < 60) return "${difference.inMinutes} phút trước";
  if (difference.inHours < 24) return "${difference.inHours} giờ trước";
  return "${difference.inDays} ngày trước";
}
