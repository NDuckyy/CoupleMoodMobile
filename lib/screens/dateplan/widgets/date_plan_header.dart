import 'package:flutter/material.dart';

class DatePlanHeader extends StatelessWidget {
  const DatePlanHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Lịch hẹn hò',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(icon: const Icon(Icons.add), onPressed: () {}),
            IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
