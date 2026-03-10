import 'package:couple_mood_mobile/providers/user/user_provider.dart';
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

                  /// PROFILE HEADER
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: user?.avatarUrl != null
                            ? NetworkImage(user!.avatarUrl!)
                            : null,
                        child: user?.avatarUrl == null
                            ? const Icon(Icons.person)
                            : null,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.fullName ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
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
                        onPressed: () {
                          context.pushNamed("edit_profile");
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// QUICK ACTIONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _actionButton(
                        icon: Icons.article_outlined,
                        label: "Tường nhà",
                        onTap: () {
                          context.pushNamed("my_posts");
                        },
                      ),

                      _actionButton(
                        icon: Icons.favorite_border,
                        label: "Hẹn hò",
                        onTap: () {},
                      ),

                      _actionButton(
                        icon: Icons.photo_library_outlined,
                        label: "Ảnh",
                        onTap: () {},
                      ),

                      _actionButton(
                        icon: Icons.notifications,
                        label: "Test Noti",
                        onTap: () async {
                          await NotificationService().showTestNotification();
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

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

                  /// ACCOUNT
                  const Text(
                    'Tài khoản',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  _tile(Icons.lock_outline, "Mật khẩu", () {}),
                  _tile(Icons.notifications_none, "Thông báo", () {}),

                  const SizedBox(height: 16),

                  /// SERVICES
                  const Text(
                    'Dịch vụ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  _tile(Icons.confirmation_number_outlined, "Voucher", () {}),
                  _tile(Icons.account_balance_wallet_outlined, "Ví", () {}),
                  _tile(Icons.history, "Lịch sử hẹn hò", () {}),

                  const SizedBox(height: 24),

                  /// OTHER
                  const Text(
                    'Khác',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),

                  _tile(Icons.star_border, "Đánh giá", () {}),
                  _tile(Icons.help_outline, "Trợ giúp", () {}),
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
