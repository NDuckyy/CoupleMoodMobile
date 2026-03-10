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
    final venueProvider = context.watch<VenueDetailProvider>();
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      height: 130,
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

                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: coupleMoodTypes
                            .map((mood) => _MoodChip(label: mood.name))
                            .toList(),
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
  final String label;

  const _MoodChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF7AEF8), Color(0xFFB388EB)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
