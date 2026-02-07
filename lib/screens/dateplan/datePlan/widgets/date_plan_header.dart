import 'package:couple_mood_mobile/providers/date_plan_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final created = await context.pushNamed('create_date_plan');

                if (created == true) {
                  if (!context.mounted) return;
                  context.read<DatePlanProvider>().fetchDatePlans(page: 1);
                }
              },
            ),
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
