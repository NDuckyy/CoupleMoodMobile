import 'package:couple_mood_mobile/widgets/voucher/voucher_badges.dart';
import 'package:flutter/material.dart';
import 'package:couple_mood_mobile/models/voucher/voucher_item_model.dart';
import 'package:couple_mood_mobile/utils/currency_utils.dart';

class VoucherCard extends StatelessWidget {
  final VoucherItem voucher;
  final VoidCallback? onExchange;
  final bool isLoading;

  const VoucherCard({
    super.key,
    required this.voucher,
    this.onExchange,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 360;
    final bool isOutOfStock = voucher.remainingQuantity <= 0;
    final bool isLowStock =
        voucher.remainingQuantity > 0 && voucher.remainingQuantity <= 5;

    final String discountText = voucher.discountAmount != null
        ? CurrencyUtils.formatVND(voucher.discountAmount!)
        : "${voucher.discountPercent?.toStringAsFixed(0)}%";

    final double progress = voucher.quantity > 0
        ? (voucher.quantity - voucher.remainingQuantity) / voucher.quantity
        : 1.0;

    final bool isOutOfUsage =
        voucher.usageLimitPerMember != null &&
        (voucher.remainingUsagePerMember ?? 0) <= 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // ==================== HEADER IMAGE ====================
              Stack(
                children: [
                  SizedBox(
                    height: 165,
                    width: double.infinity,
                    child:
                        voucher.imageUrl != null && voucher.imageUrl!.isNotEmpty
                        ? Image.network(
                            voucher.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholderImage(),
                          )
                        : _placeholderImage(),
                  ),

                  /// Gradient overlay
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

                  ///  BADGES
                  if (isSmallScreen)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VoucherDiscountBadge(
                            screenWidth: screenWidth,
                            discountText: discountText,
                          ),
                          const SizedBox(height: 6),
                          // VoucherStatusBadge(screenWidth: screenWidth),
                        ],
                      ),
                    )
                  else ...[
                    Positioned(
                      top: screenWidth * 0.04,
                      left: screenWidth * 0.04,
                      child: VoucherDiscountBadge(
                        screenWidth: screenWidth,
                        discountText: discountText,
                      ),
                    ),
                    // Positioned(
                    //   top: screenWidth * 0.04,
                    //   right: screenWidth * 0.04,
                    //   child: VoucherStatusBadge(screenWidth: screenWidth),
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
                        _buildExpireText(voucher),
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

              // ==================== CONTENT ====================
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      voucher.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      voucher.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.45,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 20),

                    // Progress
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 7,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation(
                                Color(0xFF8E4DFF),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          isOutOfStock
                              ? "HẾT HÀNG"
                              : "Còn ${voucher.remainingQuantity}/${voucher.quantity}",
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: isLowStock
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: isOutOfStock
                                ? Colors.red
                                : isLowStock
                                ? Colors.orange
                                : Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _buildUsageText(voucher),
                      style: TextStyle(
                        fontSize: 13.5,
                        color: _usageColor(voucher),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Points + Button
                    Row(
                      children: [
                        // Point box
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.monetization_on,
                                color: Color(0xFFFFB300),
                                size: 26,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${voucher.pointPrice}",
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5D4037),
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                "điểm",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // Exchange Button
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (isOutOfStock || isLoading || isOutOfUsage)
                              ? null
                              : onExchange,
                          child: AnimatedScale(
                            scale: isLoading ? 0.95 : 1.0,
                            duration: const Duration(milliseconds: 150),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 26,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                color: (isOutOfStock || isOutOfUsage)
                                    ? Colors.grey.shade300
                                    : const Color(
                                        0xFFFF4E9E,
                                      ), // Hồng chính của CoupleMood
                                boxShadow: (isOutOfStock || isOutOfUsage)
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFFF4E9E,
                                          ).withOpacity(0.35),
                                          blurRadius: 14,
                                          offset: const Offset(0, 6),
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.06),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: isLoading
                                    ? const SizedBox(
                                        key: ValueKey("loading"),
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.card_giftcard_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            key: const ValueKey("text"),
                                            isOutOfStock
                                                ? "Hết hàng"
                                                : isOutOfUsage
                                                ? "Hết lượt"
                                                : "Đổi ngay",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15.5,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
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
    );
  }

  Widget _placeholderImage() {
    return Image.asset(
      'lib/assets/images/voucher_placeholder.png',
      fit: BoxFit.cover,
      colorBlendMode: BlendMode.darken,
      color: Colors.black.withOpacity(0.2),
    );
  }
}

// Helper functions
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
