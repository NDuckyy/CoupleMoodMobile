import 'package:couple_mood_mobile/models/recommendation/recommendation_request.dart';
import 'package:couple_mood_mobile/providers/mood_provider.dart';
import 'package:couple_mood_mobile/providers/recommendation_provider.dart';
import 'package:couple_mood_mobile/screens/location/widget/venue_card.dart';
import 'package:couple_mood_mobile/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ListLocationScreen extends StatefulWidget {
  const ListLocationScreen({super.key});

  @override
  State<ListLocationScreen> createState() => _ListLocationScreenState();
}

class _ListLocationScreenState extends State<ListLocationScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final position = await LocationService.getCurrentPosition();

      if (position != null) {
        debugPrint(
            'Current position: Lat ${position.latitude}, Lon ${position.longitude}');
        if (!mounted) return;
        context.read<RecommendationProvider>().fetchRecommendations(
          RecommendationRequest(
            latitude: position.latitude,
            longitude: position.longitude,
            radiusKm: 5,
            area: "79",
          ),
        );
      } else {
        if (!mounted) return;
        context.read<RecommendationProvider>().fetchRecommendations(
          RecommendationRequest(),
        );
      }

      context.read<MoodProvider>().getCurrentMood();
    });
  }

  @override
  Widget build(BuildContext context) {
    final recommendationProvider = context.watch<RecommendationProvider>();
    final moodProvider = context.watch<MoodProvider>();
    final recs =
        recommendationProvider.recommendationResponse?.recommendations ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Danh sách địa điểm'),
            centerTitle: true,
            pinned: true,
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => context.pushNamed("filter_location"),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE1E1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm địa điểm',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// MOOD
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4FB),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'Tâm trạng cặp đôi hiện tại là: ${moodProvider.userCurrentMood ?? "Đang tải..."}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          /// CONTENT
          if (recommendationProvider.isLoading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (recommendationProvider.error != null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  recommendationProvider.error!,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else if (recs.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('Không có địa điểm phù hợp')),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverList.separated(
                itemCount: recs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final r = recs[index];
                  return VenueCard(r: r);
                },
              ),
            ),
        ],
      ),
    );
  }
}
