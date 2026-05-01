import 'package:flutter/material.dart';

enum LocationSource { self, partner, middle }

class LocationSourceSelector extends StatelessWidget {
  final LocationSource selected;
  final bool hasPartner;
  final Function(LocationSource) onChanged;

  const LocationSourceSelector({
    super.key,
    required this.selected,
    required this.hasPartner,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _item(
            context,
            label: "Vị trí của bạn",
            icon: Icons.my_location,
            isSelected: selected == LocationSource.self,
            onTap: () => onChanged(LocationSource.self),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _item(
            context,
            label: "Ở giữa",
            icon: Icons.place,
            isSelected: selected == LocationSource.middle,
            disabled: !hasPartner,
            onTap: () {
              if (!hasPartner) return;
              onChanged(LocationSource.middle);
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _item(
            context,
            label: "Đối phương",
            icon: Icons.favorite,
            isSelected: selected == LocationSource.partner,
            disabled: !hasPartner,
            onTap: () {
              if (!hasPartner) return;
              onChanged(LocationSource.partner);
            },
          ),
        ),
      ],
    );
  }

  Widget _item(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isSelected,
    bool disabled = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: disabled
              ? Colors.grey.shade200
              : isSelected
              ? const Color(0xFFB388EB)
              : const Color(0xFFF1F2F6),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: disabled
                  ? Colors.grey
                  : isSelected
                  ? Colors.white
                  : Colors.black87,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: disabled
                    ? Colors.grey
                    : isSelected
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
