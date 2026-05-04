import 'package:couple_mood_mobile/models/venue/location_tag_model.dart';
import 'package:couple_mood_mobile/providers/venue/venue_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderCard extends StatelessWidget {
  final String name;
  final String address;
  final List<String> coverImages;
  final List<LocationTag> coupleMoodTypes;

  const HeaderCard({
    super.key,
    required this.name,
    required this.address,
    required this.coverImages,
    required this.coupleMoodTypes,
  });

  @override
  Widget build(BuildContext context) {
    final moods = coupleMoodTypes;
    final total = moods.length;
    final venueProvider = context.watch<VenueDetailProvider>();
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF7AEF8).withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
      ),

      child: venueProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: coverImages.isNotEmpty
                      ? Image.network(
                          coverImages.first,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 90,
                          height: 90,
                          color: const Color.fromARGB(250, 255, 255, 255),
                          child: const Icon(Icons.image),
                        ),
                ),

                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              address,
                              style: const TextStyle(color: Colors.black54),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        height: 32,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: moods
                              .map(
                                (m) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: _MoodChip(tag: m),
                                ),
                              )
                              .toList(),
                        ),
                      ),

                      SizedBox(height: 6),

                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 14,
                            color: Color(0xFFB388EB),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$total",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFB388EB),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "tâm trạng",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
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

class _MoodChip extends StatelessWidget {
  final LocationTag tag;

  const _MoodChip({required this.tag});

  void _showDescription(BuildContext context) {
    final desc = tag.description;

    if (desc == null || desc.isEmpty) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tag.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(desc),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showDescription(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFB388EB).withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          tag.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
