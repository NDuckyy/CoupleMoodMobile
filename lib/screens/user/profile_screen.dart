import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/providers/couple_location_provider.dart';
import 'package:couple_mood_mobile/providers/couple_provider.dart';
import 'package:couple_mood_mobile/providers/user/user_provider.dart';
import 'package:couple_mood_mobile/services/location_service.dart';
import 'package:couple_mood_mobile/widgets/profile/profile_header.dart';
import 'package:couple_mood_mobile/widgets/profile/profile_tile.dart';
import 'package:couple_mood_mobile/widgets/profile/profile_white_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScrollController _scrollController = ScrollController();
  double _headerOpacity = 1.0;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    Future.microtask(() {
      context.read<UserProvider>().fetchMe();
    });
  }

  void _onScroll() {
    if (!mounted) return;

    // Khi scroll xuống dưới 180px thì bắt đầu làm mờ header
    final offset = _scrollController.offset;
    final newOpacity = (1.0 - (offset / 180).clamp(0.0, 1.0));

    if ((newOpacity - _headerOpacity).abs() > 0.02) {
      setState(() {
        _headerOpacity = newOpacity;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _logout() {
    final auth = context.read<AuthProvider>();
    LocationService.stopListening();
    context.read<CoupleLocationProvider>().disposeListener();
    context.read<CoupleLocationProvider>().reset();
    context.read<CoupleProvider>().reset();
    context.read<UserProvider>().reset();
    auth.logout();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      context.goNamed("login");
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;
    final subscription = userProvider.subscription;
    final hasSub = userProvider.hasActiveSubscription;

    return Scaffold(
      backgroundColor: const Color(0xFF7B33BB).withOpacity(0.7),
      body: RefreshIndicator(
        onRefresh: () async => await userProvider.fetchMe(),
        child: Stack(
          children: [
            /// ================= MAIN SCROLLABLE CONTENT =================
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      /// ================= HEADER: NAME + AVATAR + SUBSCRIPTION =================
                      SafeArea(
                        bottom: false,
                        child: Opacity(
                          opacity: _headerOpacity,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                            child: Column(
                              children: [
                                ProfileHeader(
                                  user: user,
                                  subscription: subscription,
                                  hasSub: hasSub,
                                  opacity: _headerOpacity,

                                  onEditProfile: () async {
                                    final result = await context.pushNamed(
                                      "edit_profile",
                                    );
                                    if (result == true) userProvider.fetchMe();
                                  },

                                  onViewSubscription: () {
                                    context.pushNamed("subscriptions");
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// ================= WHITE CONTENT =================
                      ProfileWhiteSheet(
                        accountItems: [
                          ProfileTile(
                            icon: Icons.article_outlined,
                            title: "Tường nhà",
                            color: Colors.blue,
                            onTap: () => context.pushNamed("my_posts"),
                          ),
                          ProfileTile(
                            icon: Icons.lock_outline,
                            title: "Mật khẩu",
                            color: Colors.red,
                            onTap: () => context.pushNamed("change_password"),
                          ),
                          ProfileTile(
                            icon: Icons.notifications_none,
                            title: "Thông báo",
                            color: Colors.orange,
                            onTap: () => context.pushNamed("notification"),
                          ),
                        ],

                        serviceItems: [
                          ProfileTile(
                            icon: Icons.confirmation_number_outlined,
                            title: "Voucher",
                            color: Colors.purple,
                            onTap: () => context.pushNamed(
                              'voucher',
                              queryParameters: {'tab': '1'},
                            ),
                          ),
                          ProfileTile(
                            icon: Icons.account_balance_wallet_outlined,
                            title: "Ví",
                            color: Colors.green,
                            onTap: () => context.pushNamed(
                              'wallet',
                              queryParameters: {'tab': '0'},
                            ),
                          ),
                          ProfileTile(
                            icon: Icons.rate_review_outlined,
                            title: "Đánh giá của tôi",
                            color: Colors.orange,
                            onTap: () => context.pushNamed("my_reviews"),
                          ),
                        ],

                        otherItems: [
                          ProfileTile(
                            icon: Icons.privacy_tip_outlined,
                            title: "Điều khoản & Chính sách",
                            color: Colors.indigo,
                            onTap: () => context.push('/policy'),
                          ),
                          ProfileTile(
                            icon: Icons.help_outline,
                            title: "Trợ giúp",
                            color: Colors.blue,
                            onTap: () => context.pushNamed("faq"),
                          ),
                          ProfileTile(
                            icon: Icons.logout,
                            title: "Đăng xuất",
                            color: Colors.red,
                            onTap: _logout,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// ================= STICKY MINI HEADER khi scroll lên =================
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: AnimatedOpacity(
                  opacity: _headerOpacity < 0.3
                      ? 1.0
                      : 0.0, // hiện khi header chính mờ khá nhiều
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B33BB).withOpacity(0.98),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: user?.avatarUrl != null
                              ? NetworkImage(user!.avatarUrl!)
                              : null,
                          child: user?.avatarUrl == null
                              ? const Icon(Icons.person, size: 18)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            user?.memberProfile?.fullName ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 22,
                          ),
                          onPressed: () async {
                            final result = await context.pushNamed(
                              "edit_profile",
                            );
                            if (result == true) userProvider.fetchMe();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (userProvider.isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
