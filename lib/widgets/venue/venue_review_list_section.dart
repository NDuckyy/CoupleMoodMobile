import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/venue/venue_review_provider.dart';
import 'venue_review_item.dart';

class VenueReviewListSection extends StatelessWidget {
  const VenueReviewListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VenueReviewProvider>();

    if (provider.reviews.isEmpty) {
      return const Text('Chưa có đánh giá nào');
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.reviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        return VenueReviewItem(review: provider.reviews[i]);
      },
    );
  }
}
