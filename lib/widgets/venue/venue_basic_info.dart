import 'package:couple_mood_mobile/models/venue_model.dart';
import 'package:flutter/material.dart';

import 'venue_title_row.dart';
import 'venue_tag.dart';
import 'venue_description.dart';

class VenueBasicInfo extends StatelessWidget {
  final Venue venue;

  const VenueBasicInfo({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    final firstTag = venue.locationTags.isNotEmpty
        ? venue.locationTags.first
        : null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VenueTitleRow(
            name: venue.name,
            rating: venue.averageRating,
            reviewCount: venue.reviewCount,
          ),
          const SizedBox(height: 6),

          if (firstTag != null)
            VenueTag(text: firstTag.couplePersonalityType.name),

          const SizedBox(height: 12),
          VenueDescription(description: venue.description),
        ],
      ),
    );
  }
}
