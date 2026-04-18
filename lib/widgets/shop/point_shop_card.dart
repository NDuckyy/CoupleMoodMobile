import 'package:flutter/material.dart';

class PointShopCard extends StatelessWidget {
  final int points;
  final VoidCallback? onTap;
  final bool isLarge;

  const PointShopCard({
    super.key,
    required this.points,
    this.onTap,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final double paddingHorizontal = isLarge ? 22 : 17;
    final double fontSize = isLarge ? 20.5 : 18;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal,
          vertical: isLarge ? 12 : 9,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFE4F0), Color(0xFFFFD6EB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            // Shadow hồng rất nhẹ
            BoxShadow(
              color: const Color(0xFFFF4E9E).withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
            // Shadow đen siêu nhẹ để tạo chiều sâu
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: const Color(0xFFFF4E9E).withOpacity(0.18),
            width: 1.1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_rounded,
              color: const Color(0xFFFF4E9E),
              size: isLarge ? 28 : 24,
            ),
            const SizedBox(width: 8),

            Text(
              points.toString(),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2C2C2C),
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(width: 6),

            Text(
              "điểm",
              style: TextStyle(
                fontSize: isLarge ? 15 : 13.8,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF9F1C9F).withOpacity(0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
