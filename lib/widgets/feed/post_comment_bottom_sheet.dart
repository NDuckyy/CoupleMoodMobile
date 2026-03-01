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
                            /// Level 1
                            CommentItem(
                              comment: comment,
                              showViewReplies: comment.replyCount > 0,
                              isExpanded: provider.isExpanded(comment.id),
                              loadingReplies: provider.isLoadingReplies(
                                comment.id,
                              ),
                              onViewReplies: () =>
                                  provider.loadReplies(comment),
                            ),

                            /// Level 2
                            ...provider.getReplies(comment.id).map((reply) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommentItem(
                                    comment: reply,
                                    showViewReplies: reply.replyCount > 0,
                                    isExpanded: provider.isExpanded(reply.id),
                                    loadingReplies: provider.isLoadingReplies(
                                      reply.id,
                                    ),
                                    onViewReplies: () =>
                                        provider.loadReplies(reply),
                                  ),

                                  /// Level 3
                                  ...provider
                                      .getReplies(reply.id)
                                      .map((lv3) => CommentItem(comment: lv3)),
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
              child: Row(
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
                    onPressed: () {
                      // TODO: Gọi API post comment
                      _controller.clear();
                    },
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
