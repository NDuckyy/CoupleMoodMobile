import 'package:couple_mood_mobile/models/voucher/member_voucher_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyVoucherCard extends StatelessWidget {
  final MemberVoucherItem voucher;
  final VoidCallback? onTap;

  const MyVoucherCard({super.key, required this.voucher, this.onTap});

  Color getStatusColor() {
    if (voucher.isUsed) return Colors.orange;
    if (voucher.isExpired) return Colors.red;
    return Colors.green;
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = voucher.isExpired || voucher.isUsed;

    return Opacity(
      opacity: isDisabled ? 0.6 : 1,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),

            /// 🔥 SAME STYLE AS VoucherCard
            gradient: const LinearGradient(
              colors: [
                Color(0xFFF3E5F5), // tím nhạt
                Color(0xFFEDE7F6),
              ],
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              /// 🎟 LEFT DISCOUNT (đổi sang tím)
              Container(
                width: 90,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFB388EB), Color(0xFF8093F1)],
                  ),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      voucher.discountText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "OFF",
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),

              /// 🎟 RIGHT CONTENT
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITLE
                      Text(
                        voucher.voucherTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// CODE
                      Text(
                        "Code: ${voucher.itemCode}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// DATE
                      Text(
                        voucher.isUsed
                            ? "Đã dùng: ${formatDate(voucher.usedAt!)}"
                            : "HSD: ${formatDate(voucher.expiredAt)}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// STATUS BADGE (giữ logic, chỉ tweak nhẹ UI)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor().withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          voucher.status,
                          style: TextStyle(
                            color: getStatusColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
