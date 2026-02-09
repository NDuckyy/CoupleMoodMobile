import 'package:couple_mood_mobile/screens/dateplan/datePlanItem/widget/edit_date_plan_item_button.dart';
import 'package:couple_mood_mobile/screens/dateplan/datePlanItem/widget/venue_address.dart';
import 'package:couple_mood_mobile/screens/dateplan/datePlanItem/widget/venue_title.dart';
import 'package:couple_mood_mobile/widgets/venue/venue_image.dart';
import 'package:flutter/material.dart';
import 'package:couple_mood_mobile/models/dateplan/date_plan_item_response.dart';
import 'package:couple_mood_mobile/screens/dateplan/datePlanItem/widget/note_section.dart';
import 'package:couple_mood_mobile/screens/dateplan/datePlanItem/widget/time_range_badge.dart';
import 'package:go_router/go_router.dart';

class DatePlanItemCard extends StatelessWidget {
  final ListDatePlanItem item;

  const DatePlanItemCard({super.key, required this.item});

  void _onEditPressed(BuildContext context) {
    context.pushNamed(
      'date_plan_item_edit',
      extra: {'datePlanId': item.datePlanId, 'datePlanItemId': item.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 3,
      color: Colors.white,
      shadowColor: const Color(0x33B388EB),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VenueImage(
            imageUrl: item.venueLocation.coverImage.isNotEmpty
                ? item.venueLocation.coverImage[0]
                : '',
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VenueTitle(
                  name: item.venueLocation.name,
                  venueId: item.venueLocation.id,
                ),
                const SizedBox(height: 12),

                TimeRangeBadge(
                  startTime: item.startTime,
                  endTime: item.endTime,
                ),

                const SizedBox(height: 10),
                VenueAddress(address: item.venueLocation.address),

                const SizedBox(height: 14),
                NoteSection(note: item.note),

                const SizedBox(height: 14),
                EditDatePlanItemButton(
                  onPressed: () => _onEditPressed(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
