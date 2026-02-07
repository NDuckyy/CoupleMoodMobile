import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/venue_review_provider.dart';
import 'venue_review_summary_section.dart';
import 'venue_review_list_section.dart';
import '../common/pagination_bar.dart';

class VenueReviewSection extends StatelessWidget {
  final int venueId;

  const VenueReviewSection({super.key, required this.venueId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VenueReviewProvider>();

    if (provider.loading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.summary == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ĐÁNH GIÁ CHUNG
          VenueReviewSummarySection(summary: provider.summary!),

          const SizedBox(height: 20),

          /// LIST REVIEW
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Đánh giá nổi bật',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              VenueReviewListSection(),
            ],
          ),

          const SizedBox(height: 12),

          /// PAGINATION
          PaginationBar(
            currentPage: provider.currentPage,
            totalPages: provider.totalPages,
            onPageChanged: (p) {
              context.read<VenueReviewProvider>().loadPage(
                venueId: venueId,
                page: p,
              );
            },
          ),
        ],
      ),
    );
  }
}
