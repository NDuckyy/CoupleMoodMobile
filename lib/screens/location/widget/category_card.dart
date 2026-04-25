import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFB388EB), Color(0xFF8093F1)],
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.transparent
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
            ),
          ],
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.favorite_rounded,
              size: 18,
              color: isSelected ? Colors.white : const Color(0xFFB388EB),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}