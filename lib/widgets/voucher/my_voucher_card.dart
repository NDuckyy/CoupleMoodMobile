import 'package:couple_mood_mobile/models/voucher/member_voucher_item.dart';
import 'package:couple_mood_mobile/utils/currency_utils.dart';
import 'package:couple_mood_mobile/utils/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:couple_mood_mobile/widgets/voucher/voucher_badges.dart';
import 'package:couple_mood_mobile/models/report/report_target_type.dart';
import 'package:couple_mood_mobile/widgets/report/report_bottom_sheet.dart';

class MyVoucherCard extends StatelessWidget {
  final MemberVoucherItem voucher;
  final VoidCallback? onTap;

  const MyVoucherCard({super.key, required this.voucher, this.onTap});

  // ==================== DISCOUNT TEXT ĐÃ SỬA ====================
  String get discountDisplay {
    if (voucher.discountType == "PERCENTAGE") {
      final percent = voucher.discountPercent?.toStringAsFixed(0) ?? "0";
      return "$percent%"; // 👈 chỉ trả value
    } else if (voucher.discountType == "FIXED_AMOUNT" &&
        voucher.discountAmount != null) {
      return CurrencyUtils.formatVND(voucher.discountAmount!); // 👈 chỉ value
    }
    return "";
  }

  String get statusText {
    if (voucher.isUsed) return "ĐÃ DÙNG";
    if (voucher.isExpired) return "HẾT HẠN";
    return "SẴN SÀNG";
  }

  Color get statusColor {
    if (voucher.isUsed) return Colors.orange;
    if (voucher.isExpired) return Colors.red;
    return const Color(0xFF4CAF50);
  }

  IconData get statusIcon {
    if (voucher.isUsed) return Icons.check_circle;
    if (voucher.isExpired) return Icons.cancel;
    return Icons.verified;
  }

  @override
  Widget build(BuildContext context) {
    // final bool isDisabled = voucher.isExpired || voucher.isUsed;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 360;

    return Opacity(
      opacity: 1.0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // ==================== HEADER WITH IMAGE ====================
                  Stack(
                    children: [
                      SizedBox(
                        height: 155,
                        width: double.infinity,
                        child:
                            voucher.imageUrl != null &&
                                voucher.imageUrl!.isNotEmpty
                            ? Image.network(
                                voucher.imageUrl!,
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
                                Colors.black.withOpacity(0.70),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Badges
                      if (isSmallScreen)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VoucherDiscountBadge(
                                screenWidth: screenWidth,
                                discountText: discountDisplay,
                              ),
                              const SizedBox(height: 6),
                              VoucherStatusBadge(
                                screenWidth: screenWidth,
                                text: statusText,
                                color: statusColor,
                                icon: statusIcon,
                              ),
                            ],
                          ),
                        )
                      else ...[
                        Positioned(
                          top: 16,
                          left: 16,
                          child: VoucherDiscountBadge(
                            screenWidth: screenWidth,
                            discountText: discountDisplay,
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: VoucherStatusBadge(
                            screenWidth: screenWidth,
                            text: statusText,
                            color: statusColor,
                            icon: statusIcon,
                          ),
                        ),
                      ],

                      // Voucher Code
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.45),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Mã: ${voucher.itemCode}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ==================== CONTENT ====================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                voucher.voucherTitle,
                                style: const TextStyle(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            if (voucher.isUsed)
                              GestureDetector(
                                onTap: () {
                                  showReportBottomSheet(
                                    context: context,
                                    targetId: voucher.voucherItemId,
                                    targetType: ReportTargetType.voucher,
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.flag_outlined,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Date Info
                        Row(
                          children: [
                            Icon(
                              voucher.isUsed
                                  ? Icons.event_available
                                  : Icons.calendar_today,
                              size: 19,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                voucher.isUsed
                                    ? "Đã sử dụng: ${formatDateTimeVN(voucher.usedAt!)}"
                                    : voucher.isExpired
                                    ? "Đã hết hạn: ${formatDateTimeVN(voucher.expiredAt)}"
                                    : "Hạn sử dụng: ${formatDateTimeVN(voucher.expiredAt)}",
                                style: TextStyle(
                                  fontSize: 13.8,
                                  color: voucher.isUsed
                                      ? Colors.orange.shade700
                                      : voucher.isExpired
                                      ? Colors.red
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Locations
                        if (voucher.locations.isNotEmpty)
                          Row(
                            children: [
                              const Icon(
                                Icons.store_outlined,
                                size: 19,
                                color: Color(0xFF757575),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  voucher.locations
                                      .map((e) => e.venueLocationName)
                                      .join(", "),
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Image.asset(
      'lib/assets/images/voucher_placeholder.png',
      fit: BoxFit.cover,
      color: Colors.grey.shade200,
    );
  }
}
