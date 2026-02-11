import 'package:couple_mood_mobile/models/venue/venue_model.dart';
import 'package:flutter/material.dart';

import 'venue_title_row.dart';
import 'venue_tag.dart';
import 'venue_description.dart';
import 'venue_favorite_info.dart';

class VenueBasicInfo extends StatelessWidget {
  final Venue venue;

  const VenueBasicInfo({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VenueTitleRow(
            name: venue.name,
            rating: venue.averageRating,
            reviewCount: venue.reviewCount,
            categories: venue.categories,
          ),

          const SizedBox(height: 12),

          // ===== MOOD =====
          if (venue.coupleMoodTypes.isNotEmpty) ...[
            const _SectionTitle(icon: Icons.mood, text: 'Tâm trạng'),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: venue.coupleMoodTypes
                  .map((e) => VenueTag(text: e.name))
                  .toList(),
            ),
            const SizedBox(height: 12),
          ],

          // ===== PERSONALITY =====
          if (venue.couplePersonalityTypes.isNotEmpty) ...[
            const _SectionTitle(icon: Icons.psychology, text: 'Tính cách'),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: venue.couplePersonalityTypes
                  .map((e) => VenueTag(text: e.name))
                  .toList(),
            ),
            const SizedBox(height: 12),
          ],

          VenueDescription(description: venue.description),

          const SizedBox(height: 8),

          const VenueFavoriteInfo(),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SectionTitle({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
