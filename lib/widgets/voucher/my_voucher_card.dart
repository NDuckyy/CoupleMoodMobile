import 'package:couple_mood_mobile/models/voucher/member_voucher_item.dart';
import 'package:flutter/material.dart';

class MyVoucherCard extends StatelessWidget {
  final MemberVoucherItem voucher;
  final VoidCallback? onTap;

  const MyVoucherCard({super.key, required this.voucher, this.onTap});

  Color getStatusColor(String status) {
    switch (status) {
      case "ACQUIRED":
        return Colors.green;
      case "USED":
        return Colors.orange;
      case "EXPIRED":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6)],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    voucher.voucherTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Text(
                  //   voucher.voucherDescription ?? "Không có mô tả",
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: const TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                  const SizedBox(height: 8),
                  Text(
                    "HSD: ${voucher.expiredAt.day}/${voucher.expiredAt.month}/${voucher.expiredAt.year}",
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              voucher.status,
              style: TextStyle(
                color: getStatusColor(voucher.status),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
