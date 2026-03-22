import 'package:couple_mood_mobile/providers/payment/payment_result_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:couple_mood_mobile/utils/currency_utils.dart';
import 'package:intl/intl.dart';

class PaymentResultScreen extends StatelessWidget {
  const PaymentResultScreen({super.key});

  void _goHome(BuildContext context) {
    context.go('/home');
  }

  String formatDate(DateTime? date) {
    if (date == null) return '--';
    return DateFormat('dd/MM/yyyy HH:mm').format(date.toLocal());
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentResultProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kết quả thanh toán"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _goHome(context),
        ),
      ),
      body: Center(
        child: provider.isLoading
            ? const CircularProgressIndicator()
            : provider.error != null
            ? Text("Lỗi: ${provider.error}")
            : _buildContent(context, provider),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PaymentResultProvider provider) {
    final status = provider.status!;
    final isSuccess = provider.isSuccess;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: 1,
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            child: Icon(
              isSuccess ? Icons.verified_rounded : Icons.error_rounded,
              size: 90,
              color: isSuccess ? Colors.green : Colors.redAccent,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            isSuccess ? "Thanh toán thành công 🎉" : "Thanh toán thất bại",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Text(
            status.description ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 25),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _row("Số tiền", CurrencyUtils.formatVND(status.amount ?? 0)),
                _row("Tiền tệ", status.currency ?? 'VND'),
                _row("Phương thức", status.paymentMethod ?? '--'),
                _row("Bắt đầu", formatDate(status.startDate)),
                _row("Kết thúc", formatDate(status.endDate)),
                _row(
                  "Trạng thái",
                  isSuccess ? "Đã kích hoạt" : "Chưa kích hoạt",
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _goHome(context),
              child: const Text("Về trang chủ"),
            ),
          ),
        ],
      ),
    );
  }
}
