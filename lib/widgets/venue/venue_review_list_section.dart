import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        return VenueReviewItem(
          review: provider.reviews[i],
          onDelete: () => context.read<VenueReviewProvider>().deleteReview(
            provider.reviews[i].id,
          ),
          onEdit: () async {
            final result = await context.pushNamed(
              'review_venue',
              extra: {
                'venueLocationId': provider.reviews[i].venueId,
                'review': provider.reviews[i],
              },
            );

            ///TODO: cho chim cuts luôn pagination
            if (result == true) {
              await context.read<VenueReviewProvider>().loadPage(
                venueId: provider.reviews[i].venueId,
                page: 1,
              );
            }
          },
        );
      },
    );
  }
}
