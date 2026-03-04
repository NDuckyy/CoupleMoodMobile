import 'package:flutter/material.dart';
import '../../models/venue/venue_review.dart';

class VenueReviewItem extends StatelessWidget {
  final VenueReview review;

  const VenueReviewItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
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
          /// Header: Avatar + Name + Time
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[200],
                backgroundImage: review.member.avatarUrl.isNotEmpty
                    ? NetworkImage(review.member.avatarUrl)
                    : null,
                child: review.member.avatarUrl.isEmpty
                    ? const Icon(Icons.person, size: 18)
                    : null,
              ),
              const SizedBox(width: 8),

              /// Name + rating + badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Name + Gender
                    Row(
                      children: [
                        Text(
                          review.member.displayName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 4),

                        if (review.member.gender == "FEMALE")
                          const Icon(Icons.female, size: 14, color: Colors.pink)
                        else if (review.member.gender == "MALE")
                          const Icon(Icons.male, size: 14, color: Colors.blue),
                      ],
                    ),

                    const SizedBox(height: 2),

                    ///  Rating
                    Row(
                      children: [
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

                        /// Matched badge
                        if (review.matchedTag != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              review.matchedTag!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
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
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        review.imageUrls[index],
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

  /// Format time
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
