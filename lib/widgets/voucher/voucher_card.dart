import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:couple_mood_mobile/models/voucher/voucher_item_model.dart';
import 'package:couple_mood_mobile/utils/currency_utils.dart';

class VoucherCard extends StatelessWidget {
  final VoucherItem voucher;
  final VoidCallback? onExchange;

  const VoucherCard({super.key, required this.voucher, this.onExchange});

  @override
  Widget build(BuildContext context) {
    final percentUsed = 1 - (voucher.remainingQuantity / voucher.quantity);
    final isOutOfStock = voucher.remainingQuantity <= 0;
    final isLow =
        voucher.remainingQuantity > 0 && voucher.remainingQuantity <= 5;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'lib/assets/images/collection_placeholder.png',
                fit: BoxFit.cover,
              ),
            ),

            ///  BLUR + OVERLAY
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(color: Colors.white.withOpacity(0.85)),
              ),
            ),

            ///  CONTENT
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  /// LEFT
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// DISCOUNT
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              voucher.discountAmount != null
                                  ? CurrencyUtils.formatVND(
                                      voucher.discountAmount!,
                                    )
                                  : "${voucher.discountPercent?.toStringAsFixed(0)}%",
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE53935),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Text(
                                "GIẢM",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          voucher.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          voucher.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// PROGRESS
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: percentUsed.clamp(0, 1),
                            minHeight: 5,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation(
                              Color(0xFF7E57C2),
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isOutOfStock
                                  ? "Đã hết hàng"
                                  : "Còn ${voucher.remainingQuantity}",
                              style: TextStyle(
                                fontSize: 11,
                                color: isOutOfStock
                                    ? Colors.grey
                                    : isLow
                                    ? Colors.red
                                    : Colors.grey,
                                fontWeight: isLow
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),

                            const SizedBox(height: 4),

                            ///  USAGE PER MEMBER
                            Text(
                              _buildUsageText(voucher),
                              style: TextStyle(
                                fontSize: 11,
                                color: _usageColor(voucher),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// RIGHT
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      /// STATUS
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: voucher.status == "ACTIVE"
                              ? Colors.green.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          voucher.status,
                          style: TextStyle(
                            color: voucher.status == "ACTIVE"
                                ? Colors.green
                                : Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// POINT PRICE 🔥
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.stars,
                            size: 16,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${voucher.pointPrice}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "điểm",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// BUTTON 🔥
                      InkWell(
                        onTap: voucher.remainingQuantity > 0
                            ? onExchange
                            : null,
                        borderRadius: BorderRadius.circular(20),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: voucher.remainingQuantity > 0
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFB388EB),
                                      Color(0xFF8093F1),
                                    ],
                                  )
                                : null,
                            color: voucher.remainingQuantity > 0
                                ? null
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "ĐỔI NGAY",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
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
    );
  }
}

String _buildUsageText(VoucherItem v) {
  if (v.usageLimitPerMember == null) {
    return "Không giới hạn";
  }

  final remain = v.remainingUsagePerMember ?? 0;
  final total = v.usageLimitPerMember ?? 0;

  if (remain <= 0) {
    return "Hết lượt đổi";
  }

  return "Còn $remain/$total lượt";
}

Color _usageColor(VoucherItem v) {
  if (v.usageLimitPerMember == null) return Colors.blueGrey;

  final remain = v.remainingUsagePerMember ?? 0;

  if (remain <= 0) return Colors.red;
  if (remain <= 1) return Colors.orange;

  return Colors.grey;
}
