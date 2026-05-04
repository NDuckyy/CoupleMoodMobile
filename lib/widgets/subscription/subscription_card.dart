import 'package:couple_mood_mobile/models/subscription/subscription_package.dart';
import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionPackage pkg;
  final bool selected;
  final VoidCallback onTap;
  final bool disabled;
  final bool isCurrent;

  const SubscriptionCard({
    super.key,
    required this.pkg,
    required this.selected,
    required this.onTap,
    required this.disabled,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final isYearly = pkg.isYearly;

    String? savingText;
    if (isYearly) {
      const monthly = 99000;
      final percent = ((monthly * 12 - pkg.price) / (monthly * 12) * 100)
          .round();
      savingText = "Tiết kiệm $percent%";
    }

    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: AnimatedScale(
          scale: selected ? 1.03 : 1,
          duration: const Duration(milliseconds: 200),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected
                    ? const Color.fromARGB(255, 116, 22, 107)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                /// BASE BG
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),

                /// GRADIENT overlay
                Positioned.fill(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: selected ? 1 : 0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),

                /// CONTENT
                Padding(
                  padding: const EdgeInsets.all(18), // 👈 move padding vào đây
                  child: Row(
                    children: [
                      Icon(
                        selected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: selected ? Colors.white : Colors.grey,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isYearly ? "Gói năm" : "Gói tháng",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: selected ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isYearly
                                  ? "≈ ${pkg.pricePerDay}đ/ngày"
                                  : "Thanh toán hàng tháng",
                              style: TextStyle(
                                color: selected
                                    ? Colors.white70
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${pkg.price ~/ 1000}K",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: selected ? Colors.white : Colors.black,
                            ),
                          ),
                          if (savingText != null)
                            Text(
                              savingText,
                              style: TextStyle(
                                color: selected ? Colors.white70 : Colors.green,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                if (isYearly)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4.2,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF4D8D),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Phổ biến nhất",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                if (isCurrent)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Đang sử dụng",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
