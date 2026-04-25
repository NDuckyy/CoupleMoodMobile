import 'package:flutter/material.dart';

class VoucherDiscountBadge extends StatelessWidget {
  final double screenWidth;
  final String discountText;

  const VoucherDiscountBadge({
    super.key,
    required this.screenWidth,
    required this.discountText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.035,
        vertical: screenWidth * 0.015,
      ),
      constraints: BoxConstraints(maxWidth: screenWidth * 0.45),
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
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_offer, size: 14, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              "GIẢM $discountText",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.038,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VoucherStatusBadge extends StatelessWidget {
  final double screenWidth;
  final String text;
  final Color? color;
  final IconData? icon;

  const VoucherStatusBadge({
    super.key,
    required this.screenWidth,
    this.text = "ĐANG HOẠT ĐỘNG",
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenWidth * 0.012,
      ),
      constraints: BoxConstraints(maxWidth: screenWidth * 0.4),
      decoration: BoxDecoration(
        color: color ?? Colors.green.shade600,
        borderRadius: BorderRadius.circular(20),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: Colors.white),
              const SizedBox(width: 4),
            ],
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.026,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
