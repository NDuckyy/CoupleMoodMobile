import 'package:couple_mood_mobile/models/voucher/voucher_item_model.dart';
import 'package:couple_mood_mobile/providers/voucher/voucher_detail_provider.dart';
import 'package:couple_mood_mobile/utils/currency_utils.dart';
import 'package:couple_mood_mobile/utils/time_utils.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:couple_mood_mobile/widgets/voucher/voucher_badges.dart';
import 'package:couple_mood_mobile/widgets/voucher/voucher_info_card.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
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
          final bool isOutOfUsage =
              v.usageLimitPerMember != null &&
              (v.remainingUsagePerMember ?? 0) <= 0;
          final bool canExchange =
              !isOutOfStock &&
              !isExpired &&
              !isOutOfUsage &&
              !provider.isExchanging;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // VOUCHER HEADER CARD
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBFD),
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

                                // Discount Badge and status badge
                                if (isSmallScreen)
                                  Positioned(
                                    top: 12,
                                    left: 12,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        VoucherDiscountBadge(
                                          screenWidth: screenWidth,
                                          discountText: v.discountAmount != null
                                              ? CurrencyUtils.formatVND(
                                                  v.discountAmount!,
                                                )
                                              : "${v.discountPercent?.toStringAsFixed(0)}%",
                                        ),
                                        const SizedBox(height: 6),
                                        // VoucherStatusBadge(
                                        //   screenWidth: screenWidth,
                                        // ),
                                      ],
                                    ),
                                  )
                                else ...[
                                  Positioned(
                                    top: 20,
                                    left: 20,
                                    child: VoucherDiscountBadge(
                                      screenWidth: screenWidth,
                                      discountText: v.discountAmount != null
                                          ? CurrencyUtils.formatVND(
                                              v.discountAmount!,
                                            )
                                          : "${v.discountPercent?.toStringAsFixed(0)}%",
                                    ),
                                  ),
                                  // Positioned(
                                  //   top: 20,
                                  //   right: 20,
                                  //   child: VoucherStatusBadge(
                                  //     screenWidth: screenWidth,
                                  //   ),
                                  // ),
                                ],

                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.45),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _buildExpireText(v),
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
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
                                              Icons.monetization_on,
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
                    VoucherInfoCard(
                      title: "Mô tả",
                      icon: Icons.description_rounded,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            v.description,
                            style: const TextStyle(fontSize: 15, height: 1.5),
                          ),

                          const SizedBox(height: 16),

                          // Start date
                          Row(
                            children: [
                              const Icon(
                                Icons.play_circle_outline,
                                size: 18,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Phát hành: ${formatDateTimeVN(v.startDate)}",
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          // End date
                          Row(
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                                size: 18,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Hết đổi: ${formatDateTimeVN(v.endDate)}",
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          if (v.usageValidDays != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.event_repeat,
                                  size: 18,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Hạn sử dụng: ${v.usageValidDays} ngày kể từ khi đổi",
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 12),

                          Text(
                            _buildUsageText(v),
                            style: TextStyle(
                              fontSize: 13.5,
                              color: _usageColor(v),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // áp dụng
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
                              final (success, message) = await context
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
                                  message ?? "Đổi voucher thất bại",
                                  false,
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4E9E),
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
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.card_giftcard_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  isOutOfStock
                                      ? "HẾT HÀNG"
                                      : isOutOfUsage
                                      ? "HẾT LƯỢT ĐỔI"
                                      : isExpired
                                      ? "ĐÃ HẾT HẠN"
                                      : "ĐỔI VOUCHER NGAY",
                                  style: const TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
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

  String _buildUsageText(VoucherItem v) {
    if (v.usageLimitPerMember == null) return "Không giới hạn lượt đổi";
    final remain = v.remainingUsagePerMember ?? 0;
    if (remain <= 0) return "Đã hết lượt đổi";
    return "Còn $remain/${v.usageLimitPerMember} lượt đổi";
  }

  Color _usageColor(VoucherItem v) {
    if (v.usageLimitPerMember == null) return Colors.blueGrey;
    final remain = v.remainingUsagePerMember ?? 0;
    if (remain <= 0) return Colors.red;
    if (remain <= 2) return Colors.orange;
    return Colors.grey.shade700;
  }

  String _buildExpireText(VoucherItem v) {
    final now = DateTime.now();
    final diff = v.endDate.difference(now).inDays;

    if (diff < 0) return "Đã hết hạn";
    if (diff <= 3) return "Còn $diff ngày";
    return "Hết hạn: ${v.endDate.day}/${v.endDate.month}";
  }
}
