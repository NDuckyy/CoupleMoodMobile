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

  int? _replyingToCommentId;
  String? _replyingToName;

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
                                  _replyingToCommentId = comment.id;
                                  _replyingToName = comment.author.fullName;
                                });
                              },
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
                                        _replyingToCommentId = reply.id;
                                        _replyingToName =
                                            comment.author.fullName;
                                      });
                                    },
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
                                              _replyingToCommentId = lv3.id;
                                              _replyingToName =
                                                  lv3.author.fullName;
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
                            border: InputBorder.none,
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
      ),
    );
  }
}
