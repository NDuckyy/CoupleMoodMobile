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

  Widget _buildVenueFallback() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(Icons.store, size: 10, color: Colors.grey),
    );
  }

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
          /// --- HEADER: VENUE INFO (Quan trọng nhất trong My Reviews) ---
          if (review.venueName != null) ...[
            Container(
              // Sử dụng padding thay vì margin/divider riêng lẻ
              padding: const EdgeInsets.only(bottom: 12),
              margin: const EdgeInsets.only(
                bottom: 10,
              ), // Tạo khoảng cách nhẹ với phần user bên dưới
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(
                      0.15,
                    ), // Đường kẻ cực mảnh và mờ
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Ảnh Venue: Bo góc mượt hơn
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: review.venueCoverImage.isNotEmpty
                        ? Image.network(
                            review.venueCoverImage.first,
                            width: 40, // Tăng nhẹ size để dễ nhìn
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildVenueFallback(),
                          )
                        : _buildVenueFallback(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.venueName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                            letterSpacing:
                                -0.2, // Chỉnh kerning cho chuyên nghiệp
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        // Thêm icon location nhỏ để nhấn mạnh đây là địa điểm
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 12,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Địa điểm đã đánh giá",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          /// --- USER INFO & RATING ---
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 18, // Nhỏ lại một chút vì Venue đã chiếm spotlight
                    backgroundColor: Colors.grey[200],
                    backgroundImage: avatarUrl != null
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: avatarUrl == null
                        ? const Icon(Icons.person, size: 20)
                        : null,
                  ),
                  if (!isAnonymous && frame?.thumbnailUrl != null)
                    Transform.scale(
                      scale: 1.3,
                      child: Image.network(
                        frame!.thumbnailUrl!,
                        width: 36,
                        height: 36,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        if (!isAnonymous && badge?.thumbnailUrl != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Image.network(
                              badge!.thumbnailUrl!,
                              width: 14,
                              height: 14,
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        ...List.generate(
                          review.rating,
                          (_) => const Icon(
                            Icons.star,
                            size: 12,
                            color: Colors.orange,
                          ),
                        ),
                        if (showAnonymousTag) ...[
                          const SizedBox(width: 6),
                          _buildAnonymousTag(),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// LIKE
                  GestureDetector(
                    onTap: onLike,
                    child: Row(
                      children: [
                        Icon(
                          review.isLikedByMe
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 16,
                          color: review.isLikedByMe ? Colors.red : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          review.likeCount.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// MENU (moved xuống đây)
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.more_vert,
                      size: 18,
                      color: Colors.grey[500],
                    ),
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
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Huỷ"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  "Xoá",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm != true) return;

                        try {
                          final success = await onDelete?.call();

                          if (success == true && context.mounted) {
                            showMsg(context, "Đã xoá đánh giá", true);
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
                    itemBuilder: (context) => review.isOwner
                        ? [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text("Chỉnh sửa"),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text(
                                "Xoá",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ]
                        : [
                            const PopupMenuItem(
                              value: 'report',
                              child: Text("Báo cáo"),
                            ),
                          ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// --- CONTENT ---
          Text(
            review.content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),

          /// --- IMAGES ---
          if (review.imageUrls.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.imageUrls.length,
                itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      review.imageUrls[index],
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],

          /// --- FOOTER: TIME ---
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
              const SizedBox(width: 4),
              Text(
                timeAgo(review.updatedAt ?? review.createdAt!),
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
              if (review.updatedAt != null &&
                  review.updatedAt!.isAfter(review.createdAt!))
                Text(
                  " • Đã chỉnh sửa",
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                ),
            ],
          ),

          if (review.reviewReply != null) ...[
            const SizedBox(height: 12),
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
