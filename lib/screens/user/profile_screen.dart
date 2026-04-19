import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/providers/couple_location_provider.dart';
import 'package:couple_mood_mobile/providers/user/user_provider.dart';
import 'package:couple_mood_mobile/services/location_service.dart';
import 'package:couple_mood_mobile/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<UserProvider>().fetchMe();
    });
  }

  void _logout() {
    final auth = context.read<AuthProvider>();
    LocationService.stopListening();
    context.read<CoupleLocationProvider>().disposeListener();
    context.read<CoupleLocationProvider>().reset();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin của tôi'),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HÀNG 1: Avatar + Name
                      Row(
                        children: [
                          // Phần Avatar + Frame trong ProfileScreen
                          SizedBox(
                            width: 72,
                            height: 72,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: user?.avatarUrl != null
                                      ? NetworkImage(user!.avatarUrl!)
                                      : null,
                                  child: user?.avatarUrl == null
                                      ? const Icon(Icons.person, size: 32)
                                      : null,
                                ),
                                if (user?.memberProfile?.equippedAccessories !=
                                    null)
                                  ...user!.memberProfile!.equippedAccessories!
                                      .where((e) => e.type == "FRAME")
                                      .take(1)
                                      .map(
                                        (frame) => Transform.scale(
                                          scale: 1.3,
                                          child: CachedNetworkImage(
                                            imageUrl: frame.thumbnailUrl ?? '',
                                            width: 72,
                                            height: 72,
                                            fit: BoxFit.contain,
                                            errorWidget: (_, __, ___) =>
                                                const SizedBox.shrink(),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Name + Email + Badge
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      user?.fullName ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Badge
                                    if (user
                                            ?.memberProfile
                                            ?.equippedAccessories !=
                                        null)
                                      ...user!
                                          .memberProfile!
                                          .equippedAccessories!
                                          .where((e) => e.type == "BADGE")
                                          .take(1)
                                          .map(
                                            (badge) => CachedNetworkImage(
                                              imageUrl:
                                                  badge.thumbnailUrl ?? '',
                                              width: 24,
                                              height: 24,
                                              errorWidget: (_, __, ___) =>
                                                  const SizedBox.shrink(),
                                            ),
                                          ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  user?.email ?? '',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final result = await context.pushNamed(
                                "edit_profile",
                              );
                              if (result == true) {
                                context.read<UserProvider>().fetchMe();
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // HÀNG 2: Xu + Điểm (FULL WIDTH)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _statItem(
                              icon: Icons.account_balance_wallet,
                              label: "Xu",
                              value: "${user?.balance ?? 0}",
                              onTap: () => context.pushNamed(
                                'wallet',
                                queryParameters: {'tab': '0'},
                              ),
                            ),
                            _statItem(
                              icon: Icons.stars,
                              label: "Điểm",
                              value: "${user?.points ?? 0}",
                              onTap: () => context.pushNamed(
                                'wallet',
                                queryParameters: {'tab': '1'},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  /// QUICK ACTIONS
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     _actionButton(
                  //       icon: Icons.article_outlined,
                  //       label: "Tường nhà",
                  //       onTap: () {
                  //         context.pushNamed("my_posts");
                  //       },
                  //     ),
                  //     _actionButton(
                  //       icon: Icons.favorite_border,
                  //       label: "Hẹn hò",
                  //       onTap: () {},
                  //     ),
                  //     _actionButton(
                  //       icon: Icons.photo_library_outlined,
                  //       label: "Ảnh",
                  //       onTap: () {},
                  //     ),
                  //     _actionButton(
                  //       icon: Icons.notifications,
                  //       label: "Test Noti",
                  //       onTap: () async {
                  //         await NotificationService().showTestNotification();
                  //       },
                  //     ),
                  //   ],
                  // ),

                  // const SizedBox(height: 24),

                  /// PREMIUM CARD
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      context.pushNamed("subscriptions");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8093F1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thành viên Cao cấp',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Nâng cấp để có thêm tính năng',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Tài khoản',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  _tile(Icons.article_outlined, "Tường nhà", () {
                    context.pushNamed("my_posts");
                  }),
                  _tile(Icons.lock_outline, "Mật khẩu", () {
                    context.pushNamed("change_password");
                  }),
                  _tile(Icons.notifications_none, "Thông báo", () {
                    context.pushNamed("notification");
                  }),

                  const SizedBox(height: 16),
                  const Text(
                    'Dịch vụ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  _tile(Icons.confirmation_number_outlined, "Voucher", () {}),
                  _tile(
                    Icons.account_balance_wallet_outlined,
                    "Ví",
                    () => context.pushNamed(
                      'wallet',
                      queryParameters: {'tab': '0'},
                    ),
                  ),
                  _tile(Icons.rate_review_outlined, "Đánh giá của tôi", () {
                    context.pushNamed("my_reviews");
                  }),

                  const SizedBox(height: 24),
                  const Text(
                    'Khác',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  _tile(Icons.help_outline, "Trợ giúp", () {
                    context.pushNamed("faq");
                  }),
                  _tile(Icons.logout, "Đăng xuất", () {
                    _logout();
                  }),
                ],
              ),
            ),
    );
  }

  Widget _tile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

Widget _statItem({
  required IconData icon,
  required String label,
  required String value,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Icon(icon, size: 22),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    ),
  );
}
