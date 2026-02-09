import 'package:couple_mood_mobile/models/dateplan/date_plan_response.dart';
import 'package:couple_mood_mobile/providers/date_plan_provider.dart';
import 'package:couple_mood_mobile/widgets/dialogs/show_confirm_delete_dialog.dart';
import 'package:couple_mood_mobile/widgets/datePlan/status_dot.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DatePlanCard extends StatelessWidget {
  final DatePlanDetails item;
  final VoidCallback onDelete;

  const DatePlanCard({super.key, required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final start = DateTime.parse(item.plannedStartAt).toLocal();

    final date = DateFormat('dd/MM/yyyy').format(start);
    final time = DateFormat('HH:mm').format(start);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    StatusDot(status: item.status),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: () async {
                  final result = await context.pushNamed(
                    'date_plan_edit',
                    extra: {'datePlanId': item.id},
                  );

                  if (result == true) {
                    if (!context.mounted) return;
                    context.read<DatePlanProvider>().fetchDatePlans(
                      page: context.read<DatePlanProvider>().pageNumber,
                    );
                  }
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 20,
                ),
                constraints: const BoxConstraints(),
                onPressed: () => showConfirmDeleteDialog(
                  context: context,
                  onConfirm: onDelete,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14),
              const SizedBox(width: 6),
              Text(date),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 14),
              const SizedBox(width: 6),
              Text(time),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.payments_outlined, size: 14),
              const SizedBox(width: 6),
              Text(
                item.estimatedBudget > 0
                    ? '${item.estimatedBudget} đ'
                    : 'Chưa đặt ngân sách',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.notes, size: 14),
              const SizedBox(width: 6),
              Text(
                item.note ?? 'Chưa có ghi chú',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(25),
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () {
                  context.pushNamed(
                    'date_plan_item',
                    extra: {'datePlanId': item.id},
                  );
                },
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFB388EB), Color(0xFFF7AEF8)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: const Center(
                    child: Text(
                      'Xem chi tiết',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
