import 'package:couple_mood_mobile/models/recommendation/recommendation.dart';
import 'package:couple_mood_mobile/screens/location/widget/venue_card.dart';
import 'package:couple_mood_mobile/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PopularNearby extends StatelessWidget {
  final List<Recommendation> recs;

  const PopularNearby({super.key, required this.recs});

  @override
  Widget build(BuildContext context) {
    if (recs.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.location_on_outlined,
        title: "Không có địa điểm phổ biến",
        description: "Không có địa điểm nào gần bạn.",
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Khu vực phổ biến gần bạn",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: () {
                context.pushNamed('listLocation');
              }, child: const Text("Xem tất cả")),
            ],
          ),
        ),

        SizedBox(
          height: 410,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final r = recs[index];
              return SizedBox(width: 300, child: VenueCard(r: r, maxline: 1));
            },
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}
