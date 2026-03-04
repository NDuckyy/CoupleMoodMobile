import 'package:couple_mood_mobile/models/post/comment_model.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/post/post_detail_provider.dart';
import '../../widgets/feed/comment_item.dart';

class PostCommentBottomSheet extends StatefulWidget {
  final int postId;

  const PostCommentBottomSheet({super.key, required this.postId});

  @override
  State<PostCommentBottomSheet> createState() => _PostCommentBottomSheetState();
}

class _PostCommentBottomSheetState extends State<PostCommentBottomSheet> {
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
                title: const Text(
                  "Xoá bình luận",
                  style: TextStyle(color: Colors.red),
                ),
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
      final provider = context.read<PostDetailProvider>();

      if (provider.comments.isEmpty) {
        provider.init(widget.postId);
      }
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

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 12),

            /// Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Bình luận",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            /// COMMENT LIST
            Expanded(
              child: provider.loading && provider.comments.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          provider.comments.length +
                          (provider.loadingComments ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == provider.comments.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final comment = provider.comments[index];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///  Level 1
                            CommentItem(
                              comment: comment,
                              onReply: () {
                                setState(() {
                                  _editingComment = null;
                                  _replyingToCommentId = comment.id;
                                  _replyingToName = comment.author.fullName;
                                });
                              },
                              onLongPress: () => _showCommentOptions(comment),
                              showViewReplies: comment.replyCount > 0,
                              isExpanded: provider.isExpanded(comment.id),
                              loadingReplies: provider.isLoadingReplies(
                                comment.id,
                              ),
                              onViewReplies: () =>
                                  provider.loadReplies(comment),
                              onLike: () => provider.toggleLikeComment(comment),
                            ),

                            ///  Level 2
                            ...provider.getReplies(comment.id).map((reply) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommentItem(
                                    comment: reply,
                                    onReply: () {
                                      setState(() {
                                        _editingComment = null;
                                        _replyingToCommentId = reply.id;
                                        _replyingToName =
                                            comment.author.fullName;
                                      });
                                    },
                                    onLongPress: () =>
                                        _showCommentOptions(reply),
                                    showViewReplies: reply.replyCount > 0,
                                    isExpanded: provider.isExpanded(reply.id),
                                    loadingReplies: provider.isLoadingReplies(
                                      reply.id,
                                    ),
                                    onViewReplies: () =>
                                        provider.loadReplies(reply),
                                    onLike: () =>
                                        provider.toggleLikeComment(reply),
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
                                              _replyingToName =
                                                  lv3.author.fullName;
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
                      },
                    ),
            ),

            /// INPUT
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
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

                            ///  Thanh hiển thị edit mode
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

                            ///  TextField
                            TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: _editingComment != null
                                    ? "Chỉnh sửa bình luận..."
                                    : "Viết bình luận...",
                                border: InputBorder.none,
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
                            await context
                                .read<PostDetailProvider>()
                                .editComment(
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

                          //  Reset toàn bộ state sau khi gửi
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
      ),
    );
  }
}
