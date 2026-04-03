import 'package:couple_mood_mobile/providers/voucher/my_voucher_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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

                            // Discount Badge
                            Positioned(
                              top: 20,
                              left: 20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE53935),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  v.discountText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            // Status
                            Positioned(
                              top: 20,
                              right: 20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: isUsed
                                      ? Colors.orange
                                      : isExpired
                                      ? Colors.red
                                      : Colors.green.shade600,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  isUsed
                                      ? "ĐÃ DÙNG"
                                      : isExpired
                                      ? "HẾT HẠN"
                                      : "SẴN SÀNG",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

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

                // ==================== QR CODE ====================
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Mã QR Voucher",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Image.network(
                          v.qrCodeUrl,
                          height: 200,
                          width: 200,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.qr_code,
                            size: 120,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SelectableText(
                        v.itemCode,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Chụp ảnh hoặc quét mã này để sử dụng",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ==================== CHI TIẾT & ĐỊA ĐIỂM ====================
                _buildInfoCard(
                  title: "Chi tiết voucher",
                  content: v.voucherDescription ?? "Không có mô tả thêm",
                ),

                const SizedBox(height: 16),

                if (v.locations.isNotEmpty)
                  _buildInfoCard(
                    title: "Áp dụng tại",
                    child: Column(
                      children: v.locations.map((loc) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.store,
                            color: Color(0xFF7E57C2),
                            size: 28,
                          ),
                          title: Text(loc.venueLocationName),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            context.pushNamed(
                              'venue_detail',
                              extra: {'venueId': loc.venueLocationId},
                            );
                          },
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

  Widget _buildInfoCard({
    required String title,
    String? content,
    Widget? child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (content != null)
            Text(content, style: const TextStyle(fontSize: 15, height: 1.5)),
          if (child != null) child,
        ],
      ),
    );
  }
}
