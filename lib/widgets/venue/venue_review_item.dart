import 'package:flutter/material.dart';
import '../../models/venue/venue_review.dart';

class VenueReviewItem extends StatelessWidget {
  final VenueReview review;

  const VenueReviewItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final isAnonymous = review.isAnonymous;

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Avatar
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[200],
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl)
                    : null,
                child: avatarUrl == null
                    ? const Icon(Icons.person, size: 18)
                    : null,
              ),

              const SizedBox(width: 8),

              /// Name + Rating + Tag
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Name + Gender
                    Row(
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 4),

                        if (!isAnonymous && review.member.gender == "FEMALE")
                          const Icon(Icons.female, size: 14, color: Colors.pink)
                        else if (!isAnonymous && review.member.gender == "MALE")
                          const Icon(Icons.male, size: 14, color: Colors.blue),
                      ],
                    ),

                    const SizedBox(height: 4),

                    /// Rating + Tag
                    Row(
                      children: [
                        /// Stars
                        Row(
                          children: List.generate(
                            review.rating,
                            (_) => const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.orange,
                            ),
                          ),
                        ),

                        const SizedBox(width: 6),

                        if (review.matchedTag != null)
                          _buildTag(review.matchedTag!),
                      ],
                    ),
                  ],
                ),
              ),

              /// Time
              Text(
                _formatDate(review.createdAt),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Content
          Text(review.content, style: const TextStyle(fontSize: 14)),

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

          const SizedBox(height: 8),

          /// Like row
          Row(
            children: [
              const Icon(Icons.favorite_border, size: 16),
              const SizedBox(width: 4),
              Text(
                review.likeCount.toString(),
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    final isNegative = tag.toLowerCase().contains("không");

    final bgColor = isNegative
        ? Colors.red.withOpacity(0.1)
        : Colors.green.withOpacity(0.1);

    final textColor = isNegative ? Colors.red : Colors.green;

    final icon = isNegative ? Icons.cancel : Icons.check_circle;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            tag,
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

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 0) return "${diff.inDays} ngày trước";
    if (diff.inHours > 0) return "${diff.inHours} giờ trước";
    if (diff.inMinutes > 0) return "${diff.inMinutes} phút trước";
    return "Vừa xong";
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
