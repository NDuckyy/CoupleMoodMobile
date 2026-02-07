import 'package:flutter/material.dart';
import '../../models/venue_review.dart';

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
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(review.member.avatarUrl),
                radius: 18,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.member.displayName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
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
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review.content),
        ],
      ),
    );
  }
}
