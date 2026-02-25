import 'package:couple_mood_mobile/models/advertisement/advertisement.dart';
import 'package:couple_mood_mobile/widgets/empty_widget.dart';
import 'package:flutter/material.dart';

class SpecialEvent extends StatelessWidget {
  final List<Advertisement> advertisements;
  const SpecialEvent({super.key, required this.advertisements});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Sự kiện đặc biệt",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        advertisements.isEmpty
            ? EmptyStateWidget(
                icon: Icons.event,
                title: "Không có sự kiện đặc biệt nào",
                description: "Hãy quay lại sau để xem các sự kiện mới nhất!",
              )
            : Container(
                height: 140,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: advertisements.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final ad = advertisements[index];
                    if (ad.bannerUrl == null) {
                      return Container(
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[300],
                        ),
                        child: const Placeholder(),
                      );
                    } else {
                      return Container(
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(ad.bannerUrl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
      ],
    );
  }
}
