import 'package:flutter/material.dart';

class VoucherInfoCard extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Widget? child;
  final String? content;
  final EdgeInsets? padding;

  const VoucherInfoCard({
    super.key,
    this.title,
    this.icon,
    this.child,
    this.content,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: const Color(0xFFFF4E9E), size: 26),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            if (content != null)
              Text(
                content!,
                style: const TextStyle(
                  fontSize: 15.5,
                  height: 1.6,
                  color: Color(0xFF424242),
                ),
              ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}
