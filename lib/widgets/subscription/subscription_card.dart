import 'package:couple_mood_mobile/models/subscription/subscription_package.dart';
import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionPackage pkg;
  final VoidCallback? onBuy;
  final bool isHighlighted;
  final bool isLoading;
  final bool isActive;

  const SubscriptionCard({
    super.key,
    required this.pkg,
    this.onBuy,
    this.isHighlighted = false,
    this.isLoading = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isFree = pkg.isFree;
    final isYearly = pkg.isYearly;

    final String label = isFree
        ? "GÓI MẶC ĐỊNH"
        : isYearly
        ? "GÓI NĂM"
        : "GÓI THÁNG";

    String? savingText;
    if (isYearly) {
      const monthly = 99000;
      final percent = ((monthly * 12 - pkg.price) / (monthly * 12) * 100)
          .round();
      savingText = "Tiết kiệm $percent%";
    }

    final benefits = [
      "📵 Không quảng cáo - Trải nghiệm sạch sẽ",
      "🗺️ Bản đồ tình yêu & theo dõi cặp đôi",
      "🤖 DatePlan AI tạo kế hoạch hẹn hò",
      "✨ Khung ảnh, sticker & phụ kiện Premium độc quyền",
    ];

    final textColor = isYearly ? Colors.white : Colors.black87;
    final subTextColor = isYearly ? Colors.white70 : Colors.grey.shade700;
    final accentColor = isYearly ? Colors.white : const Color(0xFF6A1B9A);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: isYearly
            ? const LinearGradient(
                colors: [Color(0xFF4A148C), Color(0xFF9C27B0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : isFree
            ? const LinearGradient(colors: [Colors.white, Color(0xFFF8F9FA)])
            : const LinearGradient(
                colors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
              ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: isYearly
                ? Colors.purple.withValues(alpha: 0.55)
                : Colors.black.withValues(alpha: 0.12),
            blurRadius: isYearly ? 35 : 20,
            offset: const Offset(0, 12),
          ),
        ],
        border: isYearly
            ? Border.all(color: Colors.white.withValues(alpha: 0.55), width: 3)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
                if (isYearly)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      "✨ TIẾT KIỆM NHẤT",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (isActive)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 30,
                  ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              isFree ? "0K" : "${pkg.price ~/ 1000}K",
              style: TextStyle(
                fontSize: isFree ? 38 : 52,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),

            Text(
              isFree
                  ? "Dùng mãi mãi"
                  : isYearly
                  ? "≈ ${pkg.pricePerDay}đ/ngày • $savingText"
                  : "≈ ${pkg.pricePerDay}đ/ngày",
              style: TextStyle(fontSize: 15, color: subTextColor),
            ),

            const SizedBox(height: 22),

            Text(
              pkg.description ?? "",
              style: TextStyle(
                fontSize: 15.5,
                height: 1.45,
                color: subTextColor,
              ),
            ),

            if (!isFree) ...[
              const SizedBox(height: 24),
              Text(
                "Bạn sẽ nhận được:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 14),
              ...benefits.map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "• ",
                        style: TextStyle(fontSize: 20, color: accentColor),
                      ),
                      Expanded(
                        child: Text(
                          b,
                          style: TextStyle(fontSize: 15, color: subTextColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (isLoading || isFree || isActive) ? null : onBuy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isYearly
                      ? Colors.white
                      : const Color(0xFF9C27B0),
                  foregroundColor: isYearly
                      ? const Color(0xFF6A1B9A)
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 26,
                        width: 26,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      )
                    : Text(
                        isActive || isFree ? "ĐANG SỬ DỤNG" : "NÂNG CẤP NGAY",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
