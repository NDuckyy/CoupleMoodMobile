import 'package:flutter/material.dart';

class ResultReasonCard extends StatelessWidget {
  final String reason;

  const ResultReasonCard({
    super.key,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xFF8093F1),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.favorite,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              reason,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}