import 'package:flutter/material.dart';

class BuildStatCard extends StatelessWidget {
  final String anniversaryDate;
  final int totalPoints;
  final int interactionPoints;

  const BuildStatCard({
    super.key,
    required this.anniversaryDate,
    required this.totalPoints,
    required this.interactionPoints,
  });

  @override
  Widget build(BuildContext context) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.favorite,
            color: const Color(0xFFF7AEF8),
            label: "Kỷ niệm",
            value: anniversaryDate,
          ),

          _divider(),

          _buildStatItem(
            icon: Icons.workspace_premium,
            color: const Color(0xFFB388EB),
            label: "Couple point",
            value: "$totalPoints",
          ),

          _divider(),

          _buildStatItem(
            icon: Icons.flash_on,
            color: const Color(0xFF72DDF7),
            label: "Điểm tương tác",
            value: "$interactionPoints",
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
      ),
      Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
    ],
  );
}
