import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:couple_mood_mobile/models/voucher/voucher_item_model.dart';
import 'package:couple_mood_mobile/utils/currency_utils.dart';

class VoucherCard extends StatelessWidget {
  final VoucherItem voucher;

  const VoucherCard({super.key, required this.voucher});

  @override
  Widget build(BuildContext context) {
    final percentUsed = 1 - (voucher.remainingQuantity / voucher.quantity);

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

                        Text(
                          "Còn ${voucher.remainingQuantity}",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// RIGHT
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        voucher.status,
                        style: TextStyle(
                          color: voucher.status == "ACTIVE"
                              ? Colors.green
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "HSD\n${voucher.endDate.day}/${voucher.endDate.month}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1EAFE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "ĐỔI NGAY",
                          style: TextStyle(
                            color: Color(0xFF6A1B9A),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
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
