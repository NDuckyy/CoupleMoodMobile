import 'package:couple_mood_mobile/providers/advertisement_provider.dart';
import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/providers/couple_location_provider.dart';
import 'package:couple_mood_mobile/providers/date_plan_provider.dart';
import 'package:couple_mood_mobile/providers/mood_provider.dart';
import 'package:couple_mood_mobile/providers/recommendation_provider.dart';
import 'package:couple_mood_mobile/screens/home/widget/advertisement_carousel.dart';
import 'package:couple_mood_mobile/screens/home/widget/advertisement_popup.dart';
import 'package:couple_mood_mobile/screens/home/widget/context.dart';
import 'package:couple_mood_mobile/screens/home/widget/couple_mood_card.dart';
import 'package:couple_mood_mobile/screens/home/widget/home_header.dart';
import 'package:couple_mood_mobile/screens/home/widget/popular_nearby.dart';
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
    LocationService.stopListening();
    context.read<CoupleLocationProvider>().disposeListener();
    auth.logout();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      context.goNamed("login");
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<MoodProvider>().getCoupleCurrentMood();
      _getPopularNearby();
      _getContextRecommendation();
      // _getSpecialEvent();
      _getAdvertisement();
      showAdvertisement();
      getDatePlanCalender();
    });
  }

  void getDatePlanCalender() async {
    final provider = context.read<DatePlanProvider>();
    await provider.getDatePlanCalender();
    if (provider.error != null) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFDC5F5),
                    Color(0xFFB388EB),
                    Color(0xFF72DDF7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Bạn đang đi một mình 🥺",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Một mình thì cũng ổn… nhưng có đôi sẽ vui hơn nhiều 💑\nThử ghép đôi để cùng nhau trải nghiệm nhé!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white70,
                          ),
                          child: const Text("Để sau"),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.pushNamed("member_search");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFFB388EB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Ghép đôi 💖"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
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
      await recommendationProvider.popularNearby();
    }
  }

  void _getContextRecommendation() async {
    if (!mounted) return;
    final recommendationProvider = context.read<RecommendationProvider>();
    await recommendationProvider.fetchLocationsByContext();
  }

  // void _getSpecialEvent() async {
  //   await context.read<AdvertisementProvider>().fetchSpecialEvents();
  // }

  void _getAdvertisement() async {
    await context.read<AdvertisementProvider>().fetchAdvertisement();
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
                        child: const Text(
                          "Đóng",
                          style: TextStyle(color: Colors.white),
                        ),
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
    // _getSpecialEvent();
    _getAdvertisement();
    _getContextRecommendation();
    getDatePlanCalender();
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
    final contextRecs =
        recommendationProvider.contextRecommendationResponse?.hits ?? [];
    final datePlanProvider = context.watch<DatePlanProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFDC5F5),
                      Color(0xFFF7AEF8),
                      Colors.white,
                    ],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize:
                          MainAxisSize.min, // Cho Column co theo nội dung
                      children: [
                        const HomeHeader(),
                        const SizedBox(height: 16),
                        CoupleMoodCard(
                          coupleCurrentMood: moodProvider.coupleCurrentMood,
                        ),
                      ],
                    ),
                  ),
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
                  calendarDays:
                      datePlanProvider.datePlanCalender?.data?.days ?? [],
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
                      icon: Icons.emoji_events,
                      label: "Thử thách",
                      color: const Color(0xFFFFC857),
                      onTap: () {
                        context.pushNamed("challenge");
                      },
                    ),

                    HomeIconButton(
                      icon: Icons.leaderboard,
                      label: "BXH",
                      color: const Color(0xFFFF6B6B),
                      onTap: () {
                        context.pushNamed("leaderboard");
                      },
                    ),

                    HomeIconButton(
                      icon: Icons.card_giftcard,
                      label: "Voucher",
                      color: const Color(0xFF4CAF50),
                      onTap: () {
                        context.pushNamed("voucher");
                      },
                    ),

                    HomeIconButton(
                      icon: Icons.storefront,
                      label: "Cửa hàng",
                      color: const Color(0xFF00BFA6),
                      onTap: () {
                        context.pushNamed("shop");
                      },
                    ),

                    HomeIconButton(
                      icon: Icons.account_balance_wallet,
                      label: "Ví",
                      color: const Color(0xFF5C6BC0),
                      onTap: () {
                        context.pushNamed("wallet");
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
            // SliverToBoxAdapter(
            //   child: SpecialEvent(
            //     advertisements: advertisementProvider.specialEvents,
            //   ),
            // ),
            SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(child: ContextLocation(recs: contextRecs)),
            SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(child: PopularNearby(recs: recs)),
          ],
        ),
      ),
    );
  }
}
