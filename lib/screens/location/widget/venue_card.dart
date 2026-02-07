import 'package:couple_mood_mobile/models/recommendation/recommendation.dart';
import 'package:couple_mood_mobile/widgets/info_chip.dart';
import 'package:couple_mood_mobile/widgets/venue/venue_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const pinkBg = Color(0xFFFFF1F8);
const lavender = Color(0xFFB388EB);
const softBlue = Color(0xFF8093F1);
const mint = Color(0xFF72DDF7);
const softGrey = Color(0xFFF5F5F7);

class VenueCard extends StatelessWidget {
  final Recommendation r;
  const VenueCard({super.key, required this.r});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shadowColor: const Color(0x33B388EB),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          Stack(
            children: [
              VenueImage(
                imageUrl: r.coverImage != null && r.coverImage!.isNotEmpty
                    ? r.coverImage!.first
                    : null,
              ),
              if (r.isOpen == true)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Đang mở',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NAME
                Text(
                  r.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3B2E5A),
                  ),
                ),

                const SizedBox(height: 8),

                /// CATEGORY + DISTANCE (pill)
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    InfoChip(
                      icon: Icons.local_cafe,
                      text: r.category ?? 'Khác',
                      bgColor: const Color(0xFFFFF1F8),
                      textColor: const Color(0xFFB388EB),
                    ),
                    if (r.distanceText != null)
                      InfoChip(
                        icon: Icons.place,
                        text: r.distanceText!,
                        bgColor: const Color(0xFFEFF2FF),
                        textColor: const Color(0xFF8093F1),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                /// ADDRESS
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Color(0xFF8093F1),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        r.address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// RATING + PRICE
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6D8),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            (r.averageRating ?? 0).toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${r.reviewCount})',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '≈ ${r.avarageCost?.toInt() ?? 0}đ',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3B2E5A),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// ACTIONS
                Row(
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF8093F1),
                        side: const BorderSide(color: Color(0xFF8093F1)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.map_outlined, size: 18),
                      label: const Text('Bản đồ'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB388EB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          context.pushNamed("venue_detail", extra: r);
                        },
                        child: const Text(
                          'Chi tiết',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
