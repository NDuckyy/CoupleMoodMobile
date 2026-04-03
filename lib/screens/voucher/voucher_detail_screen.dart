import 'package:couple_mood_mobile/providers/voucher/voucher_detail_provider.dart';
import 'package:couple_mood_mobile/utils/currency_utils.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class VoucherDetailScreen extends StatefulWidget {
  final int voucherId;

  const VoucherDetailScreen({super.key, required this.voucherId});

  @override
  State<VoucherDetailScreen> createState() => _VoucherDetailScreenState();
}

class _VoucherDetailScreenState extends State<VoucherDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<VoucherDetailProvider>().fetchDetail(widget.voucherId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Chi tiết voucher"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Consumer<VoucherDetailProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          final v = provider.voucher;
          if (v == null) {
            return const Center(child: Text("Không có dữ liệu"));
          }

          final bool isOutOfStock = v.remainingQuantity <= 0;
          final bool isExpired = v.endDate.isBefore(DateTime.now());
          final bool canExchange =
              !isOutOfStock && !isExpired && !provider.isExchanging;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // ==================== VOUCHER HEADER CARD (Đẹp hơn) ====================
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          children: [
                            // Image Section - Sáng hơn, có viền nhẹ
                            Stack(
                              children: [
                                Container(
                                  height: 190,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .grey
                                        .shade100, // nền sáng khi load lỗi
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                      width: 1,
                                    ),
                                  ),
                                  child:
                                      v.imageUrl != null &&
                                          v.imageUrl!.isNotEmpty
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
                                          Colors.black.withOpacity(0.65),
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
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      v.discountAmount != null
                                          ? "${CurrencyUtils.formatVND(v.discountAmount!)} GIẢM"
                                          : "${v.discountPercent?.toStringAsFixed(0)}% GIẢM",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
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
                                      color: Colors.green.shade600,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: const Text(
                                      "ĐANG HOẠT ĐỘNG",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                // VOUCHER Text
                                const Positioned(
                                  bottom: 24,
                                  left: 24,
                                  child: Text(
                                    "VOUCHER",
                                    style: TextStyle(
                                      fontSize: 31,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 1.8,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Info Section
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    v.title,
                                    style: const TextStyle(
                                      fontSize: 18.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    v.description,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade700,
                                      height: 1.5,
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  Row(
                                    children: [
                                      // Point
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 18,
                                          vertical: 13,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFF8E1),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.star_rounded,
                                              color: Color(0xFFFFB300),
                                              size: 29,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "${v.pointPrice}",
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            const Text(
                                              "điểm",
                                              style: TextStyle(
                                                fontSize: 15.5,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const Spacer(),

                                      // Remaining Quantity
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Text(
                                            "Còn lại",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            "${v.remainingQuantity}/${v.quantity}",
                                            style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                              color: isOutOfStock
                                                  ? Colors.red
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ],
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

                    // Mô tả
                    _buildInfoCard(title: "Mô tả", content: v.description),

                    const SizedBox(height: 16),

                    // Áp dụng tại - Giữ icon venue như cũ
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
                            ), // ← Giữ icon venue đẹp
                            title: Text(
                              loc.venueLocationName,
                              style: const TextStyle(fontSize: 15.5),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
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

                    const SizedBox(height: 30),
                  ],
                ),
              ),

              // Bottom Button
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: canExchange
                          ? () async {
                              final success = await context
                                  .read<VoucherDetailProvider>()
                                  .exchangeVoucher();
                              if (!context.mounted) return;

                              if (success) {
                                showMsg(
                                  context,
                                  "Đổi voucher thành công 💜",
                                  true,
                                );
                                context
                                    .read<VoucherDetailProvider>()
                                    .fetchDetail(widget.voucherId);
                              } else {
                                showMsg(
                                  context,
                                  provider.error ?? "Đổi voucher thất bại",
                                  false,
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7E57C2),
                        disabledBackgroundColor: Colors.grey.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                      ),
                      child: provider.isExchanging
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "ĐỔI VOUCHER NGAY",
                              style: TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      color: Colors.grey.shade100,
      child: Image.asset(
        'lib/assets/images/collection_placeholder.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    Widget? child,
    String? content,
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
