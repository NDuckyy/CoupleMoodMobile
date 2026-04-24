import 'package:flutter/material.dart';

class FilterSection extends StatelessWidget {
  final String title;
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final Widget child;

  const FilterSection({
    super.key,
    required this.title,
    required this.enabled,
    required this.onToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(value: enabled, onChanged: (v) => onToggle(v!)),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          if (enabled) child,
        ],
      ),
    );
  }
}