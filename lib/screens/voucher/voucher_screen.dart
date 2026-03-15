import 'package:flutter/material.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Voucher của bạn"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          VoucherCard(
            title: "Giảm 20% Cafe",
            description: "Áp dụng tại Highlands Coffee",
            code: "LOVE20",
          ),
          SizedBox(height: 12),
          VoucherCard(
            title: "Giảm 50k Nhà hàng",
            description: "Áp dụng cho đơn từ 300k",
            code: "DINNER50",
          ),
        ],
      ),
    );
  }
}

class VoucherCard extends StatelessWidget {
  final String title;
  final String description;
  final String code;

  const VoucherCard({
    super.key,
    required this.title,
    required this.description,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.card_giftcard, size: 40, color: Colors.orange),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(description),
                const SizedBox(height: 6),
                Text(
                  "Code: $code",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
