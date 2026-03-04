import 'package:flutter/material.dart';
import '../../models/post/comment_model.dart';

class CommentItem extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback? onLike;
  final VoidCallback? onReply;
  final VoidCallback? onViewReplies;
  final VoidCallback? onLongPress;

  final bool showViewReplies;
  final bool loadingReplies;
  final bool isExpanded;

  const CommentItem({
    super.key,
    required this.comment,
    this.onLike,
    this.onReply,
    this.onViewReplies,
    this.onLongPress,
    this.showViewReplies = false,
    this.loadingReplies = false,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final double indent = (comment.level - 1) * 24.0;

    return GestureDetector(
      onLongPress: comment.isOwner ? onLongPress : null,
      child: Padding(
        padding: EdgeInsets.only(left: indent, top: 8, bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: comment.author.avatar != null
                  ? NetworkImage(comment.author.avatar!)
                  : null,
              child: comment.author.avatar == null
                  ? Text(
                      comment.author.fullName.isNotEmpty
                          ? comment.author.fullName[0]
                          : "?",
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.author.fullName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),

                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      children: [
                        if (comment.replyToMember != null)
                          TextSpan(
                            text: "@${comment.replyToMember!.fullName} ",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                        TextSpan(text: comment.content),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: onLike,
                        child: Row(
                          children: [
                            Icon(
                              comment.isLikedByMe
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 18,
                              color: comment.isLikedByMe
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text("${comment.likeCount}"),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: onReply,
                        child: const Text(
                          "Trả lời",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),

                  if (comment.replyCount > 0 &&
                      comment.level < 3 &&
                      showViewReplies)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: GestureDetector(
                        onTap: onViewReplies,
                        child: loadingReplies
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                isExpanded
                                    ? "Ẩn phản hồi"
                                    : "Xem ${comment.replyCount} phản hồi",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
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
