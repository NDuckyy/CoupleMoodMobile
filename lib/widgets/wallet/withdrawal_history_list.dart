import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/wallet/withdraw_request.dart';

class WithdrawalHistoryList extends StatelessWidget {
  final List<WithdrawRequest> requests;
  final bool isLoading;

  const WithdrawalHistoryList({
    super.key,
    required this.requests,
    required this.isLoading,
  });

  String formatVND(int amount) => NumberFormat('#,###', 'vi_VN').format(amount);

  // Tránh crash nếu số tài khoản < 4 ký tự
  String _safeLastFour(String accountNumber) {
    if (accountNumber.length <= 4) return accountNumber;
    return accountNumber.substring(accountNumber.length - 4);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (requests.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            "Chưa có lịch sử rút tiền nào",
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ),
      );
    }

    final displayList = requests.take(4).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayList.length,
      itemBuilder: (context, index) {
        final req = displayList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12, // tăng một chút cho thoải mái hơn
            ),
            leading: const Icon(Icons.account_balance, color: Colors.orange),
            title: Text(
              "${formatVND(req.amount)}đ",
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
            ),
            subtitle: Text(
              // Hiển thị 3 thông tin rõ ràng
              "${req.bankInfo.bankName} • ${_safeLastFour(req.bankInfo.accountNumber)}\n"
              "${req.bankInfo.accountName}",
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildStatusBadge(req.status),
                const SizedBox(height: 14),
                Text(
                  DateFormat('dd/MM').format(req.requestedAt),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;

    switch (status.toLowerCase()) {
      case 'success':
      case 'approved':
        color = Colors.green;
        text = "Thành công";
        break;
      case 'rejected':
        color = Colors.red;
        text = "Từ chối";
        break;
      default: // pending
        color = Colors.orange;
        text = "Đang xử lý";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
