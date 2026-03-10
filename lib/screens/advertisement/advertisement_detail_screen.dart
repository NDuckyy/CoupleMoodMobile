import 'package:couple_mood_mobile/providers/advertisement_provider.dart';
import 'package:couple_mood_mobile/widgets/full_image_screen.dart';
import 'package:couple_mood_mobile/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdvertisementDetailScreen extends StatefulWidget {
  final int advertisementId;

  const AdvertisementDetailScreen({super.key, required this.advertisementId});

  @override
  State<AdvertisementDetailScreen> createState() =>
      _AdvertisementDetailScreenState();
}

class _AdvertisementDetailScreenState extends State<AdvertisementDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AdvertisementProvider>().fetchAdvertisementDetail(
        widget.advertisementId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final advertisemnetProvider = context.watch<AdvertisementProvider>();
    final advertisement = advertisemnetProvider.advertisementDetail;

    return Scaffold(
      backgroundColor: Colors.white,
      body: advertisemnetProvider.isLoading
          ? const Center(child: Loading())
          : advertisement == null
          ? const Center(child: Text("Không có dữ liệu"))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Banner
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FullImageScreen(
                            imageUrl: advertisement.bannerUrl,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: advertisement.bannerUrl,
                      child: Image.network(
                        advertisement.bannerUrl,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title
                        Text(
                          advertisement.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        /// Content
                        Text(
                          advertisement.content,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// Venue Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Venue Name + Price
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      advertisement.venues[0].venueName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  /// Price Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF7AEF8),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "${advertisement.venues[0].venuePriceMin ~/ 1000}k - ${advertisement.venues[0].venuePriceMax ~/ 1000}k",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              /// Rating
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${advertisement.venues[0].venueAverageRating} ",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "(${advertisement.venues[0].venueReviewCount} reviews)",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              /// Address
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.location_on,
                                      size: 18,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      advertisement.venues[0].venueAddress,
                                      style: const TextStyle(
                                        height: 1.4,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
