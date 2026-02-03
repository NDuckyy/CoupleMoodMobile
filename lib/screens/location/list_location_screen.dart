import 'package:couple_mood_mobile/providers/mood_provider.dart';
import 'package:couple_mood_mobile/providers/recommendation_provider.dart';
import 'package:couple_mood_mobile/widgets/venue/venue_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' hide Image;

class ListLocationScreen extends StatefulWidget {
  const ListLocationScreen({super.key});

  @override
  State<ListLocationScreen> createState() => _ListLocationScreenState();
}

class _ListLocationScreenState extends State<ListLocationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecommendationProvider>().fetchRecommendations();
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
      appBar: AppBar(
        title: const Text('Danh sách địa điểm'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => context.pushNamed("filter_location"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4FB),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  // SizedBox(
                  //   height: 60,
                  //   width: 60,
                  //   child: Center(
                  //     child: Transform.scale(
                  //       scale: 2,
                  //       child: RiveAnimation.asset(
                  //         'lib/assets/images/untitled.riv',
                  //         fit: BoxFit.contain,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tâm trạng cặp đôi hiện tại là: ${moodProvider.userCurrentMood ?? "Đang tải..."}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Builder(
                builder: (context) {
                  if (recommendationProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (recommendationProvider.error != null) {
                    return Center(
                      child: Text(
                        recommendationProvider.error!,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (recs.isEmpty) {
                    return const Center(
                      child: Text('Không có địa điểm phù hợp'),
                    );
                  }

                  return ListView.separated(
                    itemCount: recs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final r = recs[index];

                      return Card(
                        elevation: 2,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VenueImage(imageUrl: r.imageUrl),

                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          r.venueName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                          color: const Color.fromARGB(
                                            255,
                                            8,
                                            199,
                                            46,
                                          ),
                                        ),
                                        child: Text(
                                          '${r.matchScore}% match',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),

                                  Row(
                                    children: [
                                      Text(
                                        r.category,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        '•',
                                        style: TextStyle(color: Colors.black38),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '${r.distance.toStringAsFixed(1)} km',
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  // Address
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 18,
                                        color: Colors.black45,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          r.address,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 18,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        r.rating.toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '(${r.reviewCount})',
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Giá cả ≈ ${r.estimatedBudget}đ',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  // AI reasoning (mô tả)
                                  Text(
                                    r.aiReasoning,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // Buttons
                                  Row(
                                    children: [
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          // TODO open map
                                        },
                                        icon: const Icon(
                                          Icons.map_outlined,
                                          size: 18,
                                        ),
                                        label: const Text('Bản đồ'),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            context.pushNamed("venue_detail");
                                          },
                                          child: const Text('Chi tiết'),
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
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
