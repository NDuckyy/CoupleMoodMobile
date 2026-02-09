import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DatePlanItemHeader extends StatelessWidget {
  const DatePlanItemHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => context.pop(),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.arrow_back_ios_new, size: 20),
          ),
        ),
        const SizedBox(width: 8),

        const Text(
          'Chi tiết lịch hẹn hò',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const Spacer(),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final created = await context.pushNamed(
                  'date_plan_item_create',
                );

                if (created == true) {
                  // if (!context.mounted) return;
                  // context.read<DatePlanProvider>().fetchDatePlans(page: 1);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
