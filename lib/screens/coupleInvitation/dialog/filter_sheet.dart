import 'package:couple_mood_mobile/models/coupleInvitation/member_filter.dart';
import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  final Function(MemberFilter) onApply;

  const FilterSheet({super.key, required this.onApply});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  RangeValues ageRange = const RangeValues(18, 30);
  RangeValues heightRange = const RangeValues(150, 180);
  RangeValues weightRange = const RangeValues(45, 70);

  String? city;
  String? district;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 16,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Filter",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            _buildRange(
              "Tuổi",
              ageRange,
              18,
              60,
              (v) => setState(() => ageRange = v),
            ),

            _buildRange(
              "Chiều cao (cm)",
              heightRange,
              140,
              200,
              (v) => setState(() => heightRange = v),
            ),

            _buildRange(
              "Cân nặng (kg)",
              weightRange,
              40,
              100,
              (v) => setState(() => weightRange = v),
            ),

            const SizedBox(height: 10),

            TextField(
              decoration: const InputDecoration(labelText: "Thành phố"),
              onChanged: (v) => city = v,
            ),

            TextField(
              decoration: const InputDecoration(labelText: "Quận/Huyện"),
              onChanged: (v) => district = v,
            ),

            const SizedBox(height: 20),

            /// APPLY BUTTON
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF8093F1),
                    Color(0xFFB388EB),
                    Color(0xFFF7AEF8),
                  ],
                ),
              ),
              child: TextButton(
                onPressed: () {
                  widget.onApply(
                    MemberFilter(
                      ageFrom: ageRange.start.toInt(),
                      ageTo: ageRange.end.toInt(),
                      heightFrom: heightRange.start.toInt(),
                      heightTo: heightRange.end.toInt(),
                      weightFrom: weightRange.start.toInt(),
                      weightTo: weightRange.end.toInt(),
                      city: city,
                      district: district,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  "Áp dụng",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 reusable slider UI
  Widget _buildRange(
    String label,
    RangeValues values,
    double min,
    double max,
    ValueChanged<RangeValues> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ${values.start.toInt()} - ${values.end.toInt()}",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        RangeSlider(
          values: values,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          labels: RangeLabels(
            values.start.toInt().toString(),
            values.end.toInt().toString(),
          ),
          onChanged: onChanged,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
