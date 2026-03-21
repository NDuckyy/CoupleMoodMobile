import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceRangeFilter extends StatelessWidget {
  final RangeValues values;
  final double min;
  final double max;
  final Function(RangeValues) onChanged;

  const PriceRangeFilter({
    super.key,
    required this.values,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###", "vi_VN");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mức giá",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 8),

          /// Hiển thị giá
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${formatter.format(values.start)} đ"),
              Text("${formatter.format(values.end)} đ"),
            ],
          ),

          /// Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: RangeSlider(
              values: values,
              min: min,
              max: max,
              divisions: 20,
              activeColor: const Color(0xFFB388EB),
              inactiveColor: const Color(0xFFF7AEF8).withOpacity(0.3),
              labels: RangeLabels(
                formatter.format(values.start),
                formatter.format(values.end),
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}