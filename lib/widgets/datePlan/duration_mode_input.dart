import 'package:flutter/material.dart';

class DurationModeInput extends StatefulWidget {
  final TextEditingController controller;

  const DurationModeInput({super.key, required this.controller});

  @override
  State<DurationModeInput> createState() => _DurationModeInputState();
}

class _DurationModeInputState extends State<DurationModeInput> {
  String? selected;

  final modes = [
    {
      "value": "SAME_DAY",
      "label": "Trong ngày",
      "desc": "Diễn ra trong cùng ngày",
    },
    {
      "value": "WITHIN_24_HOURS",
      "label": "Trong 24h",
      "desc": "Trong vòng 24 giờ",
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isNotEmpty) {
      selected = widget.controller.text;
    } else {
      selected = "SAME_DAY";
      widget.controller.text = "SAME_DAY";
    }
  }

  void select(String value) {
    setState(() {
      selected = value;
      widget.controller.text = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Thời lượng",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),

        Row(
          children: modes.map((mode) {
            final isSelected = selected == mode["value"];

            return Expanded(
              child: GestureDetector(
                onTap: () => select(mode["value"]!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFFF7AEF8) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.grey.shade300,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Color(0xFFB388EB).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    children: [
                      Text(
                        mode["label"]!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mode["desc"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white70 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
