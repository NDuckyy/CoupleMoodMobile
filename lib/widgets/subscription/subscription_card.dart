import 'package:couple_mood_mobile/models/subscription/subscription_package.dart';
import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionPackage pkg;
  final VoidCallback? onBuy;
  final bool highlight;
  final bool isLoading;

  const SubscriptionCard({
    super.key,
    required this.pkg,
    this.onBuy,
    this.highlight = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    /// LABEL
    String label;
    if (pkg.isYearly) {
      label = "YEARLY";
    } else if (pkg.isMonthly) {
      label = "MONTHLY";
    } else {
      label = "FREE";
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: highlight
            ? const LinearGradient(
                colors: [Color(0xFFB388EB), Color(0xFF8093F1)],
              )
            : const LinearGradient(
                colors: [Color(0xFFF5F6FA), Color(0xFFEDE7F6)],
              ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: highlight ? Colors.white70 : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (highlight)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "BEST VALUE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          /// PRICE
          Text(
            pkg.isFree ? "FREE" : "${pkg.price ~/ 1000}K",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: highlight ? Colors.white : Colors.black,
            ),
          ),

          /// PRICE PER DAY
          Text(
            pkg.isFree ? "Miễn phí" : "≈ ${pkg.pricePerDay}đ/ngày",
            style: TextStyle(
              color: highlight ? Colors.white70 : Colors.grey,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 12),

          /// DESCRIPTION
          Text(
            pkg.description ?? "",
            style: TextStyle(
              color: highlight ? Colors.white70 : Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 20),

          /// BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (isLoading || pkg.isFree)
                  ? null
                  : onBuy, // ✅ disable free
              style: ElevatedButton.styleFrom(
                backgroundColor: highlight
                    ? Colors.white
                    : const Color(0xFFB388EB),
                foregroundColor: highlight
                    ? const Color(0xFF6A1B9A)
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: highlight
                            ? const Color(0xFF6A1B9A)
                            : Colors.white,
                      ),
                    )
                  : Text(
                      pkg.isFree ? "ĐANG SỬ DỤNG" : "MUA NGAY",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
