import 'package:couple_mood_mobile/providers/voucher/my_voucher_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:couple_mood_mobile/widgets/voucher/voucher_badges.dart';
import 'package:couple_mood_mobile/widgets/voucher/voucher_info_card.dart';

class MyVoucherDetailScreen extends StatefulWidget {
  final int voucherItemId;

  const MyVoucherDetailScreen({super.key, required this.voucherItemId});

  @override
  State<MyVoucherDetailScreen> createState() => _MyVoucherDetailScreenState();
}

class _MyVoucherDetailScreenState extends State<MyVoucherDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MyVoucherDetailProvider>().fetchVoucherDetail(
        widget.voucherItemId,
      );
    });
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MyVoucherDetailProvider>();

    if (provider.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final v = provider.voucherDetail;
    if (v == null) {
      return const Scaffold(body: Center(child: Text("Không có dữ liệu")));
    }

    final bool isUsed = v.isUsed;
    final bool isExpired = v.isExpired;

    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Voucher của tôi"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ==================== VOUCHER HEADER WITH IMAGE ====================
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            // Ảnh voucher
                            SizedBox(
                              height: 190,
                              width: double.infinity,
                              child:
                                  v.imageUrl != null && v.imageUrl!.isNotEmpty
                                  ? Image.network(
                                      v.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _placeholderImage(),
                                    )
                                  : _placeholderImage(),
                            ),

                            // Gradient overlay
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.75),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            //  Badges
                            if (isSmallScreen)
                              Positioned(
                                top: 16,
                                left: 16,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    VoucherDiscountBadge(
                                      screenWidth: screenWidth,
                                      discountText: v.discountText,
                                    ),
                                    const SizedBox(height: 6),
                                    VoucherStatusBadge(
                                      screenWidth: screenWidth,
                                      text: isUsed
                                          ? "ĐÃ DÙNG"
                                          : isExpired
                                          ? "HẾT HẠN"
                                          : "SẴN SÀNG",
                                      color: isUsed
                                          ? Colors.orange
                                          : isExpired
                                          ? Colors.red
                                          : Colors.green.shade600,
                                      icon: isUsed
                                          ? Icons.check_circle
                                          : isExpired
                                          ? Icons.cancel
                                          : Icons.verified,
                                    ),
                                  ],
                                ),
                              )
                            else ...[
                              Positioned(
                                top: 20,
                                left: 20,
                                child: VoucherDiscountBadge(
                                  screenWidth: screenWidth,
                                  discountText: v.discountText,
                                ),
                              ),
                              Positioned(
                                top: 20,
                                right: 20,
                                child: VoucherStatusBadge(
                                  screenWidth: screenWidth,
                                  text: isUsed
                                      ? "ĐÃ DÙNG"
                                      : isExpired
                                      ? "HẾT HẠN"
                                      : "SẴN SÀNG",
                                  color: isUsed
                                      ? Colors.orange
                                      : isExpired
                                      ? Colors.red
                                      : Colors.green.shade600,
                                  icon: isUsed
                                      ? Icons.check_circle
                                      : isExpired
                                      ? Icons.cancel
                                      : Icons.verified,
                                ),
                              ),
                            ],

                            // Voucher Code
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: Text(
                                "CODE: ${v.itemCode}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Thông tin cơ bản
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                v.voucherTitle,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                v.voucherDescription ?? "Không có mô tả thêm",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade700,
                                  height: 1.5,
                                ),
                              ),

                              const SizedBox(height: 20),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isUsed
                                        ? "Đã sử dụng: ${formatDate(v.usedAt!)}"
                                        : "Hạn sử dụng: ${formatDate(v.expiredAt)}",
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      color: isUsed
                                          ? Colors.orange
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ==================== QR CODE CARD ====================
                const SizedBox(height: 24),

                // ==================== QR CODE - CARD ĐẶC BIỆT ====================
                VoucherInfoCard(
                  padding: EdgeInsets.zero, // Để QR chiếm hết không gian đẹp
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: const Color(0xFFFF4E9E).withOpacity(0.15),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Title với icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code_2_rounded,
                              color: const Color(0xFFFF4E9E),
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Mã QR Voucher",
                              style: TextStyle(
                                fontSize: 17.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2C2C2C),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // QR Container
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Image.network(
                            v.qrCodeUrl,
                            height: 210,
                            width: 210,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.qr_code,
                              size: 140,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Mã code
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8E1F0),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: SelectableText(
                            v.itemCode,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                              color: Color(0xFF5D4037),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 12),
                        Text(
                          "Quét mã này để sử dụng voucher",
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ==================== CHI TIẾT VOUCHER ====================
                VoucherInfoCard(
                  title: "Chi tiết voucher",
                  icon: Icons.description_rounded,
                  child: Text(
                    v.voucherDescription ?? "Không có mô tả thêm",
                    style: const TextStyle(
                      fontSize: 15.5,
                      height: 1.6,
                      color: Color(0xFF424242),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ==================== ÁP DỤNG TẠI ====================
                if (v.locations.isNotEmpty)
                  VoucherInfoCard(
                    title: "Áp dụng tại",
                    icon: Icons.store_rounded,
                    child: Column(
                      children: v.locations.map((loc) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              context.pushNamed(
                                'venue_detail',
                                extra: {'venueId': loc.venueLocationId},
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 4,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF0F5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.store,
                                      color: Color(0xFFFF4E9E),
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      loc.venueLocationName,
                                      style: const TextStyle(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImage() {
    return Image.asset(
      'lib/assets/images/collection_placeholder.png',
      fit: BoxFit.cover,
      color: Colors.grey.shade200,
    );
  }
}
