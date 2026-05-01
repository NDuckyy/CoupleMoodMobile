import 'package:couple_mood_mobile/models/recommendation/recommendation_request.dart';
import 'package:couple_mood_mobile/providers/mood_provider.dart';
import 'package:couple_mood_mobile/providers/position_provider.dart';
import 'package:couple_mood_mobile/providers/recommendation_provider.dart';
import 'package:couple_mood_mobile/screens/location/widget/current_mood_banner.dart';
import 'package:couple_mood_mobile/screens/location/widget/location_source_selector.dart';
import 'package:couple_mood_mobile/screens/location/widget/search_location.dart';
import 'package:couple_mood_mobile/screens/location/widget/venue_card_grid.dart';
import 'package:couple_mood_mobile/services/location_service.dart';
import 'package:couple_mood_mobile/widgets/empty_widget.dart';
import 'package:couple_mood_mobile/widgets/loading.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ListLocationScreen extends StatefulWidget {
  const ListLocationScreen({super.key});

  @override
  State<ListLocationScreen> createState() => _ListLocationScreenState();
}

class _ListLocationScreenState extends State<ListLocationScreen> {
  late ScrollController _scrollController;
  LocationSource _source = LocationSource.self;
  bool isSwitchingLocation = false;

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
            lat: position.latitude,
            lng: position.longitude,
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

  Future<void> _changeLocationSource(LocationSource source) async {
    if (isSwitchingLocation) return;

    setState(() {
      _source = source;
      isSwitchingLocation = true;
    });

    final recommendationProvider = context.read<RecommendationProvider>();
    final moodProvider = context.read<MoodProvider>();
    final positionProvider = context.read<PositionProvider>();

    try {
      double? lat;
      double? lng;

      if (source == LocationSource.self) {
        final position = await LocationService.getCurrentPosition();
        if (position == null) return;

        lat = position.latitude;
        lng = position.longitude;
      } else if (source == LocationSource.partner) {
        final partnerId = moodProvider.coupleCurrentMood?.partnerMemberId;
        if (partnerId == null) return;

        await positionProvider.getUserPosition(partnerId);

        if (positionProvider.error != null) {
          if (!mounted) return;
          showMsg(context, "Không lấy được vị trí đối phương", false);
          return;
        }

        lat = positionProvider.recommendedLatitude;
        lng = positionProvider.recommendedLongitude;
      } else if (source == LocationSource.middle) {
        final myPos = await LocationService.getCurrentPosition();
        final partnerId = moodProvider.coupleCurrentMood?.partnerMemberId;

        if (myPos == null || partnerId == null) return;

        await positionProvider.getUserPosition(partnerId);

        if (positionProvider.error != null) {
          if (!mounted) return;
          showMsg(context, "Không lấy được vị trí đối phương", false);
          return;
        }

        final partnerLat = positionProvider.recommendedLatitude;
        final partnerLng = positionProvider.recommendedLongitude;

        if (partnerLat == null || partnerLng == null) return;

        /// 🔥 midpoint đơn giản
        lat = (myPos.latitude + partnerLat) / 2;
        lng = (myPos.longitude + partnerLng) / 2;
      }

      await recommendationProvider.fetchRecommendations(
        RecommendationRequest(lat: lat, lng: lng),
      );
    } catch (e) {
      if (!mounted) return;
      showMsg(context, "Lỗi lấy vị trí", false);
    } finally {
      if (mounted) {
        setState(() => isSwitchingLocation = false);
      }
    }
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
    final moodProvider = context.read<MoodProvider>();
    try {
      await recommendationProvider.fetchRecommendations(
        RecommendationRequest(
          lat: recommendationProvider.latitude,
          lng: recommendationProvider.longitude,
        ),
      );
      await moodProvider.getCurrentMood();
    } catch (e) {
      if (!context.mounted) return;
      showMsg(context, 'Làm mới thất bại: ${e.toString()}', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recommendationProvider = context.watch<RecommendationProvider>();
    final page = recommendationProvider.recommendationResponse?.recommendations;
    final recs = List.of(page?.items ?? []);

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                  onPressed: () async {
                    final res = await context.pushNamed("filter_location");
                    if (res == true) {
                      if (!context.mounted) return;
                      final provider = context.read<RecommendationProvider>();
                      provider.fetchRecommendations(
                        RecommendationRequest(
                          category: provider.selectedCategory?.name,
                          minPrice: provider.priceRange.start,
                          maxPrice: provider.priceRange.end,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: LocationSourceSelector(
                  selected: _source,
                  hasPartner:
                      context
                          .watch<MoodProvider>()
                          .coupleCurrentMood
                          ?.partnerMemberId !=
                      null,
                  onChanged: (source) {
                    if (!isSwitchingLocation) {
                      _changeLocationSource(source);
                    }
                  },
                ),
              ),
            ),

            SliverToBoxAdapter(child: SearchLocation(onSubmitted: _onSearch)),

            /// MOOD
            SliverToBoxAdapter(child: CurrentMoodBanner()),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            SliverToBoxAdapter(
              child: recommendationProvider.isRefreshing
                  ? const LinearProgressIndicator()
                  : const SizedBox(),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            /// CONTENT
            if (recommendationProvider.isLoading && recs.isEmpty)
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
                child: EmptyStateWidget(
                  icon: Icons.location_off_outlined,
                  title: "Không có địa điểm phù hợp",
                  description: "Hãy thử thay đổi tiêu chí tìm kiếm của bạn.",
                ),
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
                      return VenueCardGrid(r: r, maxline: 2, lat2: recommendationProvider.latitude, lon2: recommendationProvider.longitude);
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
