import 'package:flutter/material.dart';

class TestDescriptionCard extends StatelessWidget {
  final List<String> items;
  const TestDescriptionCard({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFF8F8F8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: items
              .map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(t, style: const TextStyle(fontSize: 15)),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
