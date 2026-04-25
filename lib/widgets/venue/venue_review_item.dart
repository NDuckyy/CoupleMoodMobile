import 'package:couple_mood_mobile/models/report/report_target_type.dart';
import 'package:couple_mood_mobile/models/venue/member_accessory.dart';
import 'package:couple_mood_mobile/utils/time_utils.dart';
import 'package:couple_mood_mobile/widgets/report/report_bottom_sheet.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import '../../models/venue/venue_review.dart';

class VenueReviewItem extends StatelessWidget {
  final VenueReview review;
  final Future<bool> Function()? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onLike;

  const VenueReviewItem({
    super.key,
    required this.review,
    this.onDelete,
    this.onEdit,
    this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    final accessories = review.member.equippedAccessories;

    final frame = accessories.cast<MemberAccessory?>().firstWhere(
      (e) => e?.type == "FRAME",
      orElse: () => null,
    );

    final badge = accessories.cast<MemberAccessory?>().firstWhere(
      (e) => e?.type == "BADGE",
      orElse: () => null,
    );

    final isAnonymous = review.isAnonymous && !review.isOwner;
    final showAnonymousTag = review.isOwner && review.isAnonymous;

    final displayName = isAnonymous
        ? "Người Dùng Ẩn Danh"
        : (review.member.displayName ?? review.member.fullName ?? "Người dùng");

    final avatarUrl = (!isAnonymous && review.member.avatarUrl != null)
        ? review.member.avatarUrl!
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: review.isOwner ? Colors.yellow.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER - Avatar
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Avatar
              Stack(
                alignment: Alignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: avatarUrl != null
                            ? NetworkImage(avatarUrl)
                            : null,
                        child: avatarUrl == null
                            ? const Icon(Icons.person, size: 26)
                            : null,
                      ),

                      /// FRAME
                      if (!isAnonymous &&
                          frame?.thumbnailUrl != null &&
                          frame!.thumbnailUrl!.isNotEmpty)
                        Transform.scale(
                          scale: 1.3,
                          child: Image.network(
                            frame.thumbnailUrl!,
                            width: 44, // = radius * 2
                            height: 44,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Dòng 1: Name + Like + Menu
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// Name + Gender
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  displayName,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),

                              /// BADGE
                              if (!isAnonymous &&
                                  badge?.thumbnailUrl != null &&
                                  badge!.thumbnailUrl!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Image.network(
                                    badge.thumbnailUrl!,
                                    width: 16,
                                    height: 16,
                                  ),
                                ),

                              const SizedBox(width: 4),

                              /// GENDER
                              if (!isAnonymous &&
                                  review.member.gender == "FEMALE")
                                const Icon(
                                  Icons.female,
                                  size: 15,
                                  color: Colors.pink,
                                ),

                              if (!isAnonymous &&
                                  review.member.gender == "MALE")
                                const Icon(
                                  Icons.male,
                                  size: 15,
                                  color: Colors.blue,
                                ),
                            ],
                          ),
                        ),

                        /// Like + Menu
                        SizedBox(
                          height: 18,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: onLike,
                                child: Row(
                                  children: [
                                    Icon(
                                      review.isLikedByMe
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 16,
                                      color: review.isLikedByMe
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      review.likeCount.toString(),
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),

                              PopupMenuButton<String>(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.more_vert, size: 20),
                                position: PopupMenuPosition.under,
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    onEdit?.call();
                                  } else if (value == 'delete') {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text("Xoá đánh giá"),
                                        content: const Text(
                                          "Bạn có chắc muốn xoá đánh giá này không?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("Huỷ"),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text(
                                              "Xoá",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm != true) return;

                                    try {
                                      final success = await onDelete?.call();

                                      if (success == true && context.mounted) {
                                        showMsg(
                                          context,
                                          "Đã xoá đánh giá",
                                          true,
                                        );
                                      }
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      showMsg(context, e.toString(), false);
                                    }
                                  } else if (value == 'report') {
                                    showReportBottomSheet(
                                      context: context,
                                      targetId: review.id,
                                      targetType: ReportTargetType.review,
                                    );
                                  }
                                },
                                itemBuilder: (context) {
                                  if (review.isOwner) {
                                    return const [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, size: 18),
                                            SizedBox(width: 10),
                                            Text("Chỉnh sửa"),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              size: 18,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Xoá",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ];
                                  } else {
                                    return const [
                                      PopupMenuItem(
                                        value: 'report',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.flag,
                                              size: 18,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Báo cáo",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ];
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    /// Rating + Tag
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            review.rating,
                            (_) => const Icon(
                              Icons.star,
                              size: 15,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (review.isMatched != null)
                          _buildMatchTag(review.isMatched!),
                        if (showAnonymousTag) ...[
                          const SizedBox(width: 6),
                          _buildAnonymousTag(),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// CONTENT
          Text(review.content, style: const TextStyle(fontSize: 14)),

          /// TIME
          if (review.createdAt != null) ...[
            const SizedBox(height: 6),
            Text(
              timeAgo(review.createdAt!),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],

          /// Images
          if (review.imageUrls.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.imageUrls.length,
                itemBuilder: (_, index) {
                  final url = review.imageUrls[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => _FullScreenImageViewer(imageUrl: url),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          url,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          /// Reply from venue
          if (review.reviewReply != null) ...[
            const SizedBox(height: 10),
            _buildReplyBox(review),
          ],
        ],
      ),
    );
  }

  Widget _buildMatchTag(bool isMatched) {
    final bgColor = isMatched
        ? Colors.green.withOpacity(0.1)
        : Colors.red.withOpacity(0.1);

    final textColor = isMatched ? Colors.green : Colors.red;

    final icon = isMatched ? Icons.check_circle : Icons.cancel;

    final text = isMatched ? "Phù hợp" : "Không phù hợp";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const _FullScreenImageViewer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(child: InteractiveViewer(child: Image.network(imageUrl))),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildReplyBox(VenueReview review) {
  final reply = review.reviewReply!;

  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header
        Row(
          children: [
            const Icon(Icons.store, size: 16, color: Colors.green),
            const SizedBox(width: 6),
            Text(
              reply.venueName != null && reply.venueName!.isNotEmpty
                  ? "Phản hồi của ${reply.venueName}"
                  : "Phản hồi của chủ quán",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),

        const SizedBox(height: 6),

        /// Content
        Text(reply.content, style: const TextStyle(fontSize: 13)),

        const SizedBox(height: 6),

        /// Time
        if (reply.createdAt != null)
          Text(
            timeAgo(reply.createdAt!),
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
      ],
    ),
  );
}

Widget _buildAnonymousTag() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.grey.withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: const [
        Icon(Icons.visibility_off, size: 12, color: Colors.grey),
        SizedBox(width: 4),
        Text(
          "Ẩn danh",
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
