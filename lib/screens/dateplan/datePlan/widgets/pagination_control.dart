import 'package:couple_mood_mobile/providers/date_plan_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaginationControls extends StatelessWidget {
  const PaginationControls({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DatePlanProvider>();
    final data = provider.datePlans?.data?.pagedResult;

    if (data == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _pageButton(
            icon: Icons.chevron_left,
            enabled: data.hasPreviousPage,
            onTap: provider.previousPage,
          ),
          const SizedBox(width: 16),
          Text(
            'Trang ${provider.pageNumber}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 16),
          _pageButton(
            icon: Icons.chevron_right,
            enabled: data.hasNextPage,
            onTap: provider.nextPage,
          ),
        ],
      ),
    );
  }

  Widget _pageButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Icon(icon),
        ),
      ),
    );
  }
}
