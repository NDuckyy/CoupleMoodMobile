import 'package:couple_mood_mobile/models/recommendation/recommendation_request.dart';
import 'package:couple_mood_mobile/providers/mood_provider.dart';
import 'package:couple_mood_mobile/providers/recommendation_provider.dart';
import 'package:couple_mood_mobile/screens/location/widget/current_mood_banner.dart';
import 'package:couple_mood_mobile/screens/location/widget/search_location.dart';
import 'package:couple_mood_mobile/screens/location/widget/venue_card_grid.dart';
import 'package:couple_mood_mobile/services/location_service.dart';
import 'package:couple_mood_mobile/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class ListLocationScreen extends StatefulWidget {
  const ListLocationScreen({super.key});

  @override
  State<ListLocationScreen> createState() => _ListLocationScreenState();
}

class _ListLocationScreenState extends State<ListLocationScreen> {
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

  void _onSearch(String query) {
    final recommendationProvider = context.read<RecommendationProvider>();
    recommendationProvider.searchLocations(query);
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
    final recs = List.of(page?.items ?? []);

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

            SliverToBoxAdapter(child: SearchLocation(onSubmitted: _onSearch)),

            /// MOOD
            SliverToBoxAdapter(
              child: CurrentMoodBanner(mood: moodProvider.userCurrentMood),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            /// CONTENT
            if (recommendationProvider.isLoading)
              const SliverFillRemaining(hasScrollBody: false, child: Loading())
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
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childCount:
                      recs.length +
                      (recommendationProvider.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < recs.length) {
                      final r = recs[index];
                      return VenueCardGrid(r: r, maxline: 2);
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
