import 'package:couple_mood_mobile/models/recommendation/recommendation_request.dart';
import 'package:couple_mood_mobile/providers/mood_provider.dart';
import 'package:couple_mood_mobile/providers/recommendation_provider.dart';
import 'package:couple_mood_mobile/screens/datePlanItem/chooseLocation/widget/choose_location_venue_card.dart';
import 'package:couple_mood_mobile/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ChooseLocationScreen extends StatefulWidget {
  const ChooseLocationScreen({super.key});

  @override
  State<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final position = await LocationService.getCurrentPosition();
      if (position != null) {
        if (!mounted) return;
        final recommendationProvider = context.read<RecommendationProvider>();
        recommendationProvider.latitude = position.latitude;
        recommendationProvider.longitude = position.longitude;
        debugPrint(
          'User location: ${position.latitude}, ${position.longitude}',
        );
        recommendationProvider.fetchRecommendations(
          RecommendationRequest(
            latitude: position.latitude,
            longitude: position.longitude,
            radiusKm: 1000,
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

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<RecommendationProvider>();
      final paged = provider.recommendationResponse?.recommendations;

      if (paged?.hasNextPage == true && !provider.isLoadingMore) {
        provider.loadMore();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh(BuildContext context) async {
    final recommendationProvider = context.read<RecommendationProvider>();
    await recommendationProvider.fetchRecommendations(
      RecommendationRequest(
        latitude: recommendationProvider.latitude,
        longitude: recommendationProvider.longitude,
        radiusKm: 1000,
        area: "79",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recommendationProvider = context.watch<RecommendationProvider>();
    final moodProvider = context.watch<MoodProvider>();
    final page = recommendationProvider.recommendationResponse?.recommendations;
    final recs = page?.items ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: CustomScrollView(
          controller: _scrollController,
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
                  itemCount:
                      recs.length +
                      (recommendationProvider.isLoadingMore ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index < recs.length) {
                      final r = recs[index];
                      return ChooseLocationVenueCard(r: r);
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
