import 'package:couple_mood_mobile/providers/user/my_review_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/venue/venue_review_item.dart';

class MyReviewScreen extends StatefulWidget {
  const MyReviewScreen({super.key});

  @override
  State<MyReviewScreen> createState() => _MyReviewScreenState();
}

class _MyReviewScreenState extends State<MyReviewScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<MyReviewProvider>().fetchInitial();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = context.read<MyReviewProvider>();

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      provider.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MyReviewProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Đánh giá của tôi")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: provider.refresh,
              child: provider.reviews.isEmpty
                  ? const Center(child: Text("Bạn chưa có đánh giá nào"))
                  : ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount:
                          provider.reviews.length +
                          (provider.isLoadingMore ? 1 : 0),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        if (index < provider.reviews.length) {
                          return VenueReviewItem(
                            review: provider.reviews[index],
                            onDelete: () => context
                                .read<MyReviewProvider>()
                                .deleteReview(provider.reviews[index].id),
                          );
                        }

                        /// loading more
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
            ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
