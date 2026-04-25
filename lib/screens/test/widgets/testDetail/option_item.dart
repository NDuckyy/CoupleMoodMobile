import 'package:flutter/material.dart';

class OptionItem extends StatelessWidget {
  final String content;
  final String answerId;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionItem({
    super.key,
    required this.content,
    required this.answerId,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFFDC5F5), Color(0xFFB388EB)],
                )
              : null,
          color: isSelected ? null : const Color(0xFFF5F5F7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? Colors.transparent : Colors.grey.shade200,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFB388EB).withOpacity(0.3),
                    blurRadius: 12,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.grey,
                  width: 2,
                ),
                color:
                    isSelected ? Colors.white : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Color(0xFFB388EB))
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}