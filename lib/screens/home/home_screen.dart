import 'package:couple_mood_mobile/models/advertisement/special_event_detail.dart';
import 'package:couple_mood_mobile/providers/advertisement_provider.dart';
import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/providers/mood_provider.dart';
import 'package:couple_mood_mobile/providers/recommendation_provider.dart';
import 'package:couple_mood_mobile/screens/home/widget/advertisement_carousel.dart';
import 'package:couple_mood_mobile/screens/home/widget/advertisement_popup.dart';
import 'package:couple_mood_mobile/screens/home/widget/couple_mood_card.dart';
import 'package:couple_mood_mobile/screens/home/widget/home_header.dart';
import 'package:couple_mood_mobile/screens/home/widget/popular_nearby.dart';
import 'package:couple_mood_mobile/screens/home/widget/special_event.dart';
import 'package:couple_mood_mobile/screens/home/widget/week_selector.dart';
import 'package:couple_mood_mobile/services/location_service.dart';
import 'package:couple_mood_mobile/widgets/home_icon_button.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _logout() {
    final auth = context.read<AuthProvider>();
    auth.logout();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      context.pushNamed("login");
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<MoodProvider>().getCoupleCurrentMood();
      _getPopularNearby();
      _getSpecialEvent();
      _getAdvertisement();
      showAdvertisement();
    });
  }

  void showAdvertisement() async {
    final advertismentProvider = context.read<AdvertisementProvider>();
    await advertismentProvider.fetchAdvertisementPopup();
    if (advertismentProvider.popup == null) {
      return;
    } else {
      if (advertismentProvider.isLoadingPopup) {
        return;
      }
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AdvertisementPopup(
            bannerUrl: advertismentProvider.popup?.bannerUrl ?? "",
            onTap: () {
              context.pop();
            },
          );
        },
      );
    }
  }

  void _getPopularNearby() async {
    final position = await LocationService.getCurrentPosition();
    if (position != null) {
      if (!mounted) return;
      final recommendationProvider = context.read<RecommendationProvider>();
      recommendationProvider.latitude = position.latitude;
      recommendationProvider.longitude = position.longitude;
      debugPrint('User location: ${position.latitude}, ${position.longitude}');
      recommendationProvider.popularNearby();
    }
  }

  void _getSpecialEvent() {
    context.read<AdvertisementProvider>().fetchSpecialEvents();
  }

  void _getAdvertisement() {
    context.read<AdvertisementProvider>().fetchAdvertisement();
  }

  void _showSpecialEventDialog(BuildContext context, int eventId) async {
    await context.read<AdvertisementProvider>().fetchSpecialEventDetail(
      eventId,
    );
    final event = context.read<AdvertisementProvider>().specialEventDetail;
    if (event == null) {
      if (!mounted) return;
      showMsg(context, "Không thể tải thông tin sự kiện", false);
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  event.bannerUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      event.eventName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      event.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black87),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffB388EB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Đóng", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _refresh() async {
    _getPopularNearby();
    _getSpecialEvent();
    _getAdvertisement();
    context.read<MoodProvider>().getCoupleCurrentMood();
  }

  @override
  Widget build(BuildContext context) {
    final moodProvider = context.watch<MoodProvider>();
    final recommendationProvider = context.watch<RecommendationProvider>();
    final advertisementProvider = context.watch<AdvertisementProvider>();
    final recs =
        recommendationProvider.recommendationResponse?.recommendations.items ??
        [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: false,
              snap: false,
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              titleSpacing: 12,
              title: const HomeHeader(),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: CoupleMoodCard(
                  coupleCurrentMood: moodProvider.coupleCurrentMood,
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 16)),

            SliverToBoxAdapter(
              child: AdvertisementCarousel(
                advertisements: advertisementProvider.advertisements,
                onTapSpecialEvent: (eventId) =>
                    _showSpecialEventDialog(context, eventId),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: WeekSelector(
                  initialDate: DateTime.now(),
                  onDateSelected: (date) {
                    debugPrint(date.toString());
                  },
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1,
                  children: [
                    HomeIconButton(
                      icon: Icons.mood,
                      label: "Cảm xúc",
                      color: const Color(0xFFF7AEF8),
                      onTap: () {
                        context.pushNamed("moodChooseMethod");
                      },
                    ),

                    HomeIconButton(
                      icon: Icons.science,
                      label: "Khám phá\nbạn",
                      color: const Color(0xFFB388EB),
                      onTap: () {
                        context.pushNamed("test");
                      },
                    ),

                    HomeIconButton(
                      icon: Icons.group_add,
                      label: "Ghép cặp",
                      color: const Color(0xFF8093F1),
                      onTap: () {
                        context.pushNamed("member_search");
                      },
                    ),

                    HomeIconButton(
                      icon: Icons.collections_bookmark,
                      label: "Bộ sưu\ntập",
                      color: const Color(0xFF72DDF7),
                      onTap: () {
                        context.pushNamed("collections");
                      },
                    ),

                    HomeIconButton(
                      icon: Icons.dynamic_feed,
                      label: "Bài viết",
                      color: const Color(0xFFFFAFCC),
                      onTap: () {
                        context.pushNamed("newsfeed");
                      },
                    ),

                    HomeIconButton(
                      icon: Icons.reviews,
                      label: "Review",
                      color: const Color(0xFFFFAFCC),
                      onTap: () {
                        context.pushNamed("review_venue");
                      },
                    ),

                    HomeIconButton(
                      icon: Icons.logout,
                      label: "Đăng xuất",
                      color: const Color(0xFFB388EB),
                      onTap: () {
                        _logout();
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SpecialEvent(
                advertisements: advertisementProvider.specialEvents,
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(child: PopularNearby(recs: recs)),
          ],
        ),
      ),
    );
  }
}
