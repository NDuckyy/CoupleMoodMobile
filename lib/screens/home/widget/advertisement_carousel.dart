import 'package:couple_mood_mobile/models/advertisement/advertisement.dart';
import 'package:couple_mood_mobile/providers/advertisement_provider.dart';
import 'package:couple_mood_mobile/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdvertisementCarousel extends StatelessWidget {
  final List<Advertisement> advertisements;
  final Function(int eventId) onTapSpecialEvent;
  const AdvertisementCarousel({
    super.key,
    required this.advertisements,
    required this.onTapSpecialEvent,
  });

  void _onClickAd(BuildContext context, Advertisement ad) {
    if (ad.type == "ADVERTISEMENT") {
      if (ad.advertisementId == null) return;
      context.pushNamed(
        'advertisement_detail',
        extra: {'advertisementId': ad.advertisementId},
      );
    } else {
      onTapSpecialEvent.call(ad.specialEventId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final advertisementProvider = context.watch<AdvertisementProvider>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Những chương trình nổi bật",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        advertisements.isEmpty && !advertisementProvider.isLoadingAdvertisement
            ? EmptyStateWidget(
                icon: Icons.event,
                title: "Không có chương trình nào",
                description: "",
              )
            : advertisements.isEmpty &&
                  advertisementProvider.isLoadingAdvertisement
            ? const SizedBox(
                height: 140,
                child: Center(child: CircularProgressIndicator()),
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
                      return InkWell(
                        onTap: () => _onClickAd(context, ad),
                        child: SizedBox(
                          width: 300,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              ad.bannerUrl!,
                              fit: BoxFit.cover,

                              // loading
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const SizedBox(
                                  height: 150,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },

                              // error
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 150,
                                  color: Colors.grey.shade200,
                                  alignment: Alignment.center,
                                  child: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.broken_image,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Ảnh lỗi",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
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
