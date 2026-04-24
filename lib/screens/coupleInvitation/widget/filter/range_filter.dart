import 'package:flutter/material.dart';

class RangeFilter extends StatelessWidget {
  final RangeValues values;
  final double min;
  final double max;
  final ValueChanged<RangeValues> onChanged;

  const RangeFilter({
    super.key,
    required this.values,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("${values.start.toInt()} - ${values.end.toInt()}"),
        RangeSlider(
          values: values,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }
}