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
    final bool isOutOfStock = voucher.remainingQuantity <= 0;
    final bool isLowStock =
        voucher.remainingQuantity > 0 && voucher.remainingQuantity <= 5;

    final String discountText = voucher.discountAmount != null
        ? CurrencyUtils.formatVND(voucher.discountAmount!)
        : "${voucher.discountPercent?.toStringAsFixed(0)}%";

    final double progress = voucher.quantity > 0
        ? (voucher.quantity - voucher.remainingQuantity) / voucher.quantity
        : 1.0;

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

                  // Gradient overlay để chữ nổi
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

                  // Discount Badge (nổi bật)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "$discountText GIẢM",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),

                  // Status Badge
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "ĐANG HOẠT ĐỘNG",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // VOUCHER text
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      "VOUCHER",
                      style: TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.w900,
                        color: Colors.white.withOpacity(0.95),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),

              // ==================== CONTENT ====================
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
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

                    const SizedBox(height: 18),

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
                                Icons.star_rounded,
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
                        InkWell(
                          onTap: isOutOfStock ? null : onExchange,
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 36,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              gradient: isOutOfStock
                                  ? null
                                  : const LinearGradient(
                                      colors: [
                                        Color(0xFF9C27B0),
                                        Color(0xFF7E57C2),
                                      ],
                                    ),
                              color: isOutOfStock ? Colors.grey.shade300 : null,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              isOutOfStock ? "HẾT HÀNG" : "ĐỔI NGAY",
                              style: TextStyle(
                                color: isOutOfStock
                                    ? Colors.grey.shade700
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    Text(
                      _buildUsageText(voucher),
                      style: TextStyle(
                        fontSize: 13.5,
                        color: _usageColor(voucher),
                        fontWeight: FontWeight.w500,
                      ),
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
      'lib/assets/images/collection_placeholder.png',
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
