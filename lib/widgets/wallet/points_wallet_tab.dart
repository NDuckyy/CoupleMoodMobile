import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet/wallet_provider.dart';

class PointsWalletTab extends StatelessWidget {
  final ColorScheme colorScheme;
  const PointsWalletTab({super.key, required this.colorScheme});

  String formatPoints(int points) =>
      NumberFormat('#,###', 'vi_VN').format(points);

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final rate = wallet.exchangeRate;

    return CustomScrollView(
      slivers: [
        // === Hero Card Ví Điểm ===
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.surface,
                    colorScheme.primary,
                    colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.45),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 25,
                    offset: const Offset(10, 20),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 1.5,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Số dư điểm",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 4),
                          ],
                        ),
                        Text(
                          "${formatPoints(wallet.pointsBalance)} xu",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (rate != null)
                          Text(
                            "Tỉ lệ: ${rate.moneyAmount} VND = ${rate.pointAmount} Point",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
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

        // Nội dung Ví Điểm
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sử dụng điểm",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),

                // Placeholder cho các chức năng sau này (Voucher, Phụ kiện...)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.confirmation_number,
                          color: colorScheme.primary,
                          size: 32,
                        ),
                        title: const Text("Mua Voucher"),
                        subtitle: const Text("Đổi điểm lấy mã giảm giá"),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: colorScheme.primary,
                        ),
                        onTap: () {
                          context.pushNamed(
                            'voucher',
                            queryParameters: {'tab': '0'},
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.shopping_bag,
                          color: colorScheme.primary,
                          size: 32,
                        ),
                        title: const Text("Mua Phụ Kiện"),
                        subtitle: const Text("Shop trong ứng dụng"),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: colorScheme.primary,
                        ),
                        onTap: () {
                          context.pushNamed('shop');
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Thông tin tỉ lệ (nếu cần hiển thị thêm)
                if (rate != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.grey, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "1 Point ≈ ${rate.moneyAmount} VND\n"
                            "Bạn có thể dùng điểm để mua voucher và phụ kiện",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
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

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
