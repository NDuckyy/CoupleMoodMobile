import 'package:couple_mood_mobile/screens/datePlanItem/datePlanItem/widget/venue_address.dart';
import 'package:couple_mood_mobile/screens/datePlanItem/datePlanItem/widget/venue_title.dart';
import 'package:couple_mood_mobile/widgets/dialogs/show_confirm_delete_dialog.dart';
import 'package:couple_mood_mobile/widgets/venue/venue_image.dart';
import 'package:flutter/material.dart';
import 'package:couple_mood_mobile/models/dateplan/date_plan_item_response.dart';
import 'package:couple_mood_mobile/screens/datePlanItem/datePlanItem/widget/note_section.dart';
import 'package:couple_mood_mobile/screens/datePlanItem/datePlanItem/widget/time_range_badge.dart';
import 'package:go_router/go_router.dart';

class DatePlanItemCard extends StatelessWidget {
  final ListDatePlanItem item;
  final VoidCallback onDelete;
  final VoidCallback onReload;
  final int index;

  const DatePlanItemCard({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onReload,
    required this.index,
  });

  Future<void> _onEditPressed(BuildContext context) async {
    final res = await context.pushNamed(
      'date_plan_item_edit',
      extra: {'datePlanId': item.datePlanId, 'datePlanItemId': item.id},
    );
    if (res == true) {
      onReload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isInactive = item.venueLocation.status.toUpperCase() == "INACTIVE";
    return Container(
      margin: const EdgeInsets.only(bottom: 12), // 🔥 chuyển ra đây
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Opacity(
              opacity: isInactive ? 0.5 : 1,
              child: Card(
                margin: EdgeInsets.zero, // 🔥 QUAN TRỌNG
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 90,
                              height: 90,
                              child: VenueImage(
                                imageUrl:
                                    item.venueLocation.coverImage.isNotEmpty
                                    ? item.venueLocation.coverImage[0]
                                    : '',
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: VenueTitle(
                                        name: item.venueLocation.name,
                                        venueId: item.venueLocation.id,
                                      ),
                                    ),

                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 18,
                                      ),
                                      color: Colors.redAccent,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () => showConfirmDeleteDialog(
                                        context: context,
                                        onConfirm: onDelete,
                                      ),
                                    ),

                                    ReorderableDragStartListener(
                                      index: index,
                                      child: const Icon(
                                        Icons.drag_handle,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                TimeRangeBadge(
                                  startTime: item.startTime,
                                  endTime: item.endTime,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      VenueAddress(address: item.venueLocation.address),

                      const SizedBox(height: 8),

                      NoteSection(note: item.note),

                      const SizedBox(height: 8),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _onEditPressed(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            "Chỉnh sửa",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8093F1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (isInactive)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(color: Colors.black.withOpacity(0.1)),
                ),
              ),

            if (isInactive)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Không khả dụng",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
