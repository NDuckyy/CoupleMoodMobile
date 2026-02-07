import 'package:flutter/material.dart';
import '../../models/venue_review_summary.dart';

class VenueReviewSummarySection extends StatelessWidget {
  final VenueReviewSummary summary;

  const VenueReviewSummarySection({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          /// LEFT
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        summary.averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 2),
                        child: Icon(Icons.star, color: Colors.orange, size: 30),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 4),
              const Text(
                'Đánh giá chung',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                '${summary.totalReviews} đánh giá',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(width: 16),

          /// RIGHT
          Expanded(
            child: Column(
              children: summary.ratings.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text('${e.star}'),
                      const Icon(Icons.star, size: 14, color: Colors.orange),
                      const SizedBox(width: 6),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: e.percent / 100,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.orange,
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('${e.count}'),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
