import 'package:couple_mood_mobile/models/recommendation/recommendation_request.dart';
import 'package:couple_mood_mobile/providers/recommendation_provider.dart';
import 'package:couple_mood_mobile/screens/location/widget/search_location.dart';
import 'package:couple_mood_mobile/screens/location/widget/venue_card_grid.dart';
import 'package:couple_mood_mobile/widgets/empty_widget.dart';
import 'package:couple_mood_mobile/widgets/loading.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ListLocationContextScreen extends StatefulWidget {
  const ListLocationContextScreen({super.key});

  @override
  State<ListLocationContextScreen> createState() =>
      _ListLocationContextScreenState();
}

class _ListLocationContextScreenState extends State<ListLocationContextScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getContextRecommendation();
    });
  }

  Future<void> _getContextRecommendation() async {
    if (!mounted) return;
    final recommendationProvider = context.read<RecommendationProvider>();
    await recommendationProvider.fetchLocationsByContext();
  }

  void _onSearch(String query) {
    final recommendationProvider = context.read<RecommendationProvider>();
    recommendationProvider.searchLocationsContext(query);
  }

  Future<void> _onRefresh(BuildContext context) async {
    try {
      await _getContextRecommendation();
    } catch (e) {
      if (!context.mounted) return;
      showMsg(context, 'Làm mới thất bại: ${e.toString()}', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recommendationProvider = context.watch<RecommendationProvider>();
    final page = recommendationProvider.contextRecommendationResponse;
    final recs = List.of(page?.hits ?? []);

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              title: const Text('Gợi ý cho riêng bạn'),
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
                      await provider.fetchRecommendationsContext(
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

            SliverToBoxAdapter(child: SearchLocation(onSubmitted: _onSearch)),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            SliverToBoxAdapter(
              child: recommendationProvider.isRefreshing
                  ? const LinearProgressIndicator()
                  : const SizedBox(),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            /// CONTENT
            if (recommendationProvider.isContextLoading && recs.isEmpty)
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
                      return VenueCardGrid(
                        r: r,
                        maxline: 2,
                        lat2: recommendationProvider.latitude,
                        lon2: recommendationProvider.longitude,
                      );
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
