import 'package:couple_mood_mobile/models/post/comment_model.dart';
import 'package:couple_mood_mobile/providers/post/post_provider.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
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

  CommentModel? _editingComment;
  int? _replyingToCommentId;
  String? _replyingToName;

  void _showCommentOptions(CommentModel comment) {
    if (!comment.isOwner) return;

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Chỉnh sửa"),
                onTap: () {
                  Navigator.pop(context);

                  setState(() {
                    _editingComment = comment;

                    _replyingToCommentId = null;
                    _replyingToName = null;

                    _controller.text = comment.content;
                    _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: _controller.text.length),
                    );
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Xoá", style: TextStyle(color: Colors.red)),
                onTap: () async {
                  Navigator.pop(context);

                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text("Xoá bình luận?"),
                      content: const Text("Hành động này không thể hoàn tác."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext, false),
                          child: const Text("Huỷ"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext, true),
                          child: const Text(
                            "Xoá",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    final success = await context
                        .read<PostDetailProvider>()
                        .deleteComment(comment.id);

                    if (mounted) {
                      showMsg(
                        context,
                        success ? "Đã xoá bình luận" : "Xoá thất bại",
                        success,
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
                const SizedBox(height: 16),

                Consumer<PostProvider>(
                  builder: (context, postProvider, _) {
                    final updatedPost = postProvider.posts.firstWhere(
                      (p) => p.id == post.id,
                    );

                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              postProvider.toggleLikeById(updatedPost.id),
                          child: Row(
                            children: [
                              Icon(
                                updatedPost.isLikedByMe
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: updatedPost.isLikedByMe
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                updatedPost.likeCount.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 24),

                        Row(
                          children: [
                            const Icon(Icons.comment_outlined),
                            const SizedBox(width: 6),
                            Text(
                              updatedPost.commentCount.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),

                const Divider(height: 32),

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
                              _editingComment = null;
                              _replyingToCommentId = c.id;
                              _replyingToName = c.author.fullName;
                            });
                          },
                          onLongPress: () => _showCommentOptions(c),

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
                                    _editingComment = null;
                                    _replyingToCommentId = reply.id;
                                    _replyingToName = c.author.fullName;
                                  });
                                },
                                onLongPress: () => _showCommentOptions(reply),
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
                                          _editingComment = null;
                                          _replyingToCommentId = lv3.id;
                                          _replyingToName = lv3.author.fullName;
                                        });
                                      },
                                      onLongPress: () =>
                                          _showCommentOptions(lv3),
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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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

                          if (_editingComment != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  const Text(
                                    "Đang chỉnh sửa bình luận",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _editingComment = null;
                                        _replyingToCommentId = null;
                                        _replyingToName = null;
                                        _controller.clear();
                                      });
                                    },
                                    child: const Icon(Icons.close, size: 16),
                                  ),
                                ],
                              ),
                            ),

                          TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: _editingComment != null
                                  ? "Chỉnh sửa bình luận..."
                                  : "Viết bình luận...",
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _editingComment != null ? Icons.check : Icons.send,
                      ),
                      onPressed: () async {
                        final text = _controller.text.trim();
                        if (text.isEmpty) return;

                        if (_editingComment != null) {
                          await context.read<PostDetailProvider>().editComment(
                            commentId: _editingComment!.id,
                            newContent: text,
                          );
                        } else {
                          await context
                              .read<PostDetailProvider>()
                              .createComment(
                                content: text,
                                parentId: _replyingToCommentId,
                              );
                        }

                        // Reset toàn bộ state sau khi gửi
                        _controller.clear();

                        setState(() {
                          _editingComment = null;
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
