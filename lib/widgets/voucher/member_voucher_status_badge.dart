import 'package:flutter/material.dart';

class MemberVoucherStatusBadge extends StatelessWidget {
  final double screenWidth;
  final String text;
  final Color color;
  final IconData icon;

  const MemberVoucherStatusBadge({
    super.key,
    required this.screenWidth,
    required this.text,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenWidth * 0.012,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
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
    );
  }
}
