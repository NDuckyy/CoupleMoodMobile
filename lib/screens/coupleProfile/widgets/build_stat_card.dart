import 'package:couple_mood_mobile/utils/currency_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuildStatCard extends StatelessWidget {
  final String? anniversaryDate;
  final int? totalPoints;
  final int? interactionPoints;
  final double? budgetMin;
  final double? budgetMax;

  const BuildStatCard({
    super.key,
    required this.anniversaryDate,
    required this.totalPoints,
    required this.interactionPoints,
    this.budgetMin,
    this.budgetMax,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd-MM-yyyy');
    final parsedDate = anniversaryDate != null
        ? DateTime.tryParse(anniversaryDate!)
        : null;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildStatItem(
                    icon: Icons.favorite,
                    color: const Color(0xFFF7AEF8),
                    label: "Kỷ niệm",
                    value: parsedDate != null
                        ? formatter.format(parsedDate)
                        : "Chưa cập nhật",
                  ),
                ),
              ),

              _divider(),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _buildStatItem(
                    icon: Icons.workspace_premium,
                    color: const Color(0xFFB388EB),
                    label: "Điểm thử thách",
                    value: "$totalPoints",
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.attach_money_outlined,
                color: Colors.green,
                label: "Ngân sách",
                value:
                    budgetMin != null &&
                        budgetMax != null &&
                        (budgetMin! > 0 || budgetMax! > 0)
                    ? "${CurrencyUtils.formatVND(budgetMin!)} - ${CurrencyUtils.formatVND(budgetMax!)}"
                    : "Chưa cập nhật",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _divider() {
  return Container(height: 40, width: 1, color: Colors.grey.shade200);
}

Widget _buildStatItem({
  required IconData icon,
  required Color color,
  required String label,
  required String? value,
}) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      const SizedBox(height: 6),
      Text(
        value ?? "-",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
      Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
    ],
  );
}
