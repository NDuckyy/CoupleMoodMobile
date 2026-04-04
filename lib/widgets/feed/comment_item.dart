import 'package:couple_mood_mobile/models/venue/member_accessory.dart';
import 'package:flutter/material.dart';
import '../../models/post/comment_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    final double indent = (comment.level - 1) * 20.0;
    final accessories = comment.author.equippedAccessories ?? [];

    final frame = accessories.cast<MemberAccessory?>().firstWhere(
      (e) => e?.type == "FRAME",
      orElse: () => null,
    );

    final badge = accessories.cast<MemberAccessory?>().firstWhere(
      (e) => e?.type == "BADGE",
      orElse: () => null,
    );

    return Padding(
      padding: EdgeInsets.only(left: indent, top: 8, bottom: 8),
      child: GestureDetector(
        onLongPress: onLongPress,
        behavior: HitTestBehavior.opaque,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                /// AVATAR
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: comment.author.avatar != null
                      ? CachedNetworkImageProvider(comment.author.avatar!)
                      : null,
                  child: comment.author.avatar == null
                      ? Text(
                          comment.author.fullName.isNotEmpty
                              ? comment.author.fullName[0]
                              : "?",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      : null,
                ),

                /// FRAME
                if (frame?.thumbnailUrl != null &&
                    frame!.thumbnailUrl!.isNotEmpty)
                  Transform.scale(
                    scale: 1.2,
                    child: CachedNetworkImage(
                      imageUrl: frame.thumbnailUrl!,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      memCacheWidth: 100,
                      placeholder: (_, __) => const SizedBox.shrink(),
                      errorWidget: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 10),

            /// CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// BUBBLE
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// NAME
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              comment.author.fullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),

                            if (badge?.thumbnailUrl != null &&
                                badge!.thumbnailUrl!.isNotEmpty) ...[
                              const SizedBox(width: 4),
                              CachedNetworkImage(
                                imageUrl: badge.thumbnailUrl!,
                                width: 14,
                                height: 14,
                                fit: BoxFit.cover,
                                memCacheWidth: 50,
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 4),

                        /// CONTENT + MENTION
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.35,
                              color: Colors.black87,
                            ),
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// ACTIONS ROW
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
                              size: 16,
                              color: comment.isLikedByMe
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${comment.likeCount}",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      GestureDetector(
                        onTap: onReply,
                        child: const Text(
                          "Trả lời",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),

                  /// VIEW REPLIES
                  if (comment.replyCount > 0 &&
                      comment.level < 3 &&
                      showViewReplies)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: GestureDetector(
                        onTap: onViewReplies,
                        child: loadingReplies
                            ? const SizedBox(
                                height: 14,
                                width: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                isExpanded
                                    ? "Ẩn phản hồi"
                                    : "Xem ${comment.replyCount} phản hồi",
                                style: const TextStyle(
                                  fontSize: 12,
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
