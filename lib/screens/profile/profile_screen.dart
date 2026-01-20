import 'package:flutter/material.dart';
import 'package:couple_mood_mobile/routes/app_route.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin của tôi')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://i.pinimg.com/1200x/ec/08/3f/ec083ff29c32b972e6a9f054a9ac095b.jpg',
                  ),
                ),

                const SizedBox(width: 12),

                const Column(
                  children: [
                    Text(
                      'Huỳnh Kim Khang',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'khang@gmail.com',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                const Spacer(),

                Icon(Icons.edit, size: 18),
              ],
            ),
            const SizedBox(height: 16),

            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.subscriptions);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
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
                        fontSize: 14,
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

            const SizedBox(height: 16),
            const Text(
              'Tài khoản',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.lock_outline),
              title: const Text('Mật khẩu'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.notifications_none),
              title: const Text('Thông báo'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const SizedBox(height: 16),
            const Text(
              'Dịch vụ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.confirmation_number_outlined),
              title: const Text('Voucher'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: const Text('Ví'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.history),
              title: const Text('Lịch sử hẹn hò'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),

            const SizedBox(height: 24),
            const Text(
              'Khác',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.star_border),
              title: const Text('Đánh giá'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.help_outline),
              title: const Text('Trợ giúp'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
