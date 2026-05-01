import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/providers/couple_location_provider.dart';
import 'package:couple_mood_mobile/providers/couple_provider.dart';
import 'package:couple_mood_mobile/providers/user/user_provider.dart';
import 'package:couple_mood_mobile/services/location_service.dart';
import 'package:couple_mood_mobile/utils/time_utils.dart';
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
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
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
                                  padding: const EdgeInsets.fromLTRB(
                                    15,
                                    10,
                                    15,
                                    16,
                                  ),
                                  child: Column(
                                    children: [
                                      // Header Bar (Title)
                                      SizedBox(
                                        height: 44,
                                        child: const Center(
                                          child: Text(
                                            "Thông tin của tôi",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      // User Info Row
                                      Row(
                                        children: [
                                          // Avatar
                                          SizedBox(
                                            width: 72,
                                            height: 72,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: 32,
                                                  backgroundColor:
                                                      Colors.grey[200],
                                                  backgroundImage:
                                                      user?.avatarUrl != null
                                                      ? NetworkImage(
                                                          user!.avatarUrl!,
                                                        )
                                                      : null,
                                                  child: user?.avatarUrl == null
                                                      ? const Icon(
                                                          Icons.person,
                                                          size: 32,
                                                        )
                                                      : null,
                                                ),
                                                if (user
                                                        ?.memberProfile
                                                        ?.equippedAccessories !=
                                                    null)
                                                  ...user!
                                                      .memberProfile!
                                                      .equippedAccessories!
                                                      .where(
                                                        (e) =>
                                                            e.type == "FRAME",
                                                      )
                                                      .take(1)
                                                      .map(
                                                        (
                                                          frame,
                                                        ) => Transform.scale(
                                                          scale: 1.3,
                                                          child: CachedNetworkImage(
                                                            imageUrl:
                                                                frame
                                                                    .thumbnailUrl ??
                                                                '',
                                                            width: 72,
                                                            height: 72,
                                                            fit: BoxFit.contain,
                                                            errorWidget:
                                                                (_, __, ___) =>
                                                                    const SizedBox.shrink(),
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),

                                          const SizedBox(width: 16),

                                          // Name, Email, Points + Edit
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center, // 👈 quan trọng
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize: MainAxisSize
                                                        .min, // 👈 thêm cái này luôn cho gọn
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                              user
                                                                      ?.memberProfile
                                                                      ?.fullName ??
                                                                  '',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          if (user
                                                                  ?.memberProfile
                                                                  ?.equippedAccessories !=
                                                              null)
                                                            ...user!
                                                                .memberProfile!
                                                                .equippedAccessories!
                                                                .where(
                                                                  (e) =>
                                                                      e.type ==
                                                                      "BADGE",
                                                                )
                                                                .take(1)
                                                                .map(
                                                                  (
                                                                    badge,
                                                                  ) => CachedNetworkImage(
                                                                    imageUrl:
                                                                        badge
                                                                            .thumbnailUrl ??
                                                                        '',
                                                                    width: 22,
                                                                    height: 22,
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        user?.email ?? '',
                                                        style: TextStyle(
                                                          color: Colors.white
                                                              .withOpacity(0.9),
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .monetization_on,
                                                            size: 16,
                                                            color: Colors.amber,
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            "${user?.points ?? 0}",
                                                            style:
                                                                const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () async {
                                                    final result = await context
                                                        .pushNamed(
                                                          "edit_profile",
                                                        );
                                                    if (result == true)
                                                      userProvider.fetchMe();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 16),

                                      // Subscription Card
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.10),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    hasSub
                                                        ? (subscription
                                                                  ?.packageName ??
                                                              "Thành viên")
                                                        : "Chưa có gói",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    hasSub &&
                                                            subscription
                                                                    ?.startDate !=
                                                                null &&
                                                            subscription
                                                                    ?.endDate !=
                                                                null
                                                        ? "${formatDateTimeVN(subscription!.startDate!)} → ${formatDateTimeVN(subscription.endDate!)}"
                                                        : "Nâng cấp để sử dụng đầy đủ tính năng",
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.9),
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () => context.pushNamed(
                                                "subscriptions",
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.25),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Text(
                                                  "Xem chi tiết",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            /// ================= WHITE CONTENT =================
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(28),
                                  topRight: Radius.circular(28),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  15,
                                  20,
                                  15,
                                  20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Tài khoản',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    _tile(
                                      Icons.article_outlined,
                                      "Tường nhà",
                                      () => context.pushNamed("my_posts"),
                                      Colors.blue,
                                    ),
                                    _tile(
                                      Icons.lock_outline,
                                      "Mật khẩu",
                                      () =>
                                          context.pushNamed("change_password"),
                                      Colors.red,
                                    ),
                                    _tile(
                                      Icons.notifications_none,
                                      "Thông báo",
                                      () => context.pushNamed("notification"),
                                      Colors.orange,
                                    ),

                                    const SizedBox(height: 16),
                                    const Text(
                                      'Dịch vụ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    _tile(
                                      Icons.confirmation_number_outlined,
                                      "Voucher",
                                      () => context.pushNamed(
                                        'voucher',
                                        queryParameters: {'tab': '1'},
                                      ),
                                      Colors.purple,
                                    ),
                                    _tile(
                                      Icons.account_balance_wallet_outlined,
                                      "Ví",
                                      () => context.pushNamed(
                                        'wallet',
                                        queryParameters: {'tab': '0'},
                                      ),
                                      Colors.green,
                                    ),
                                    _tile(
                                      Icons.rate_review_outlined,
                                      "Đánh giá của tôi",
                                      () => context.pushNamed("my_reviews"),
                                      Colors.orange,
                                    ),

                                    const SizedBox(height: 16),
                                    const Text(
                                      'Khác',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    _tile(
                                      Icons.privacy_tip_outlined,
                                      "Điều khoản & Chính sách",
                                      () => context.push('/policy'),
                                      Colors.indigo,
                                    ),
                                    _tile(
                                      Icons.help_outline,
                                      "Trợ giúp",
                                      () => context.pushNamed("faq"),
                                      Colors.blue,
                                    ),
                                    _tile(
                                      Icons.logout,
                                      "Đăng xuất",
                                      _logout,
                                      Colors.red,
                                    ),
                                  ],
                                ),
                              ),
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
                ],
              ),
            ),
    );
  }

  Widget _tile(
    IconData icon,
    String title,
    VoidCallback onTap,
    Color iconColor,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
