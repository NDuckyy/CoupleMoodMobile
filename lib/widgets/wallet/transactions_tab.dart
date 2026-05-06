import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/wallet/wallet_provider.dart';
import '../../models/wallet/wallet_transaction.dart';

class TransactionsTab extends StatefulWidget {
  const TransactionsTab({super.key});

  @override
  State<TransactionsTab> createState() => _TransactionsTabState();
}

class _TransactionsTabState extends State<TransactionsTab> {
  String formatNumber(num amount) =>
      NumberFormat('#,###', 'vi_VN').format(amount);

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy HH:mm').format(date.toLocal());
  }

  // ================= CLEAN LOGIC =================

  String _currencyLabel(String? currency) {
    switch (currency) {
      case 'VND':
        return 'đ';
      case 'POINTS':
        return ' điểm';
      default:
        return '';
    }
  }

  String _statusText(String? status) {
    switch (status) {
      case 'SUCCESS':
        return 'Thành công';
      case 'FAILED':
        return 'Thất bại';
      case 'PENDING':
        return 'Đang xử lý';
      default:
        return status ?? '';
    }
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'SUCCESS':
        return Colors.green;
      case 'FAILED':
        return Colors.red;
      case 'PENDING':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _transactionColor(WalletTransaction tx) {
    switch (tx.transactionType) {
      case 'WALLET_TOPUP':
        return Colors.green;
      case 'MONEY_TO_POINT':
        return Colors.orange;
      case 'MEMBER_SUBSCRIPTION':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  IconData _transactionIcon(WalletTransaction tx) {
    switch (tx.transactionType) {
      case 'WALLET_TOPUP':
        return Icons.add_circle_outline;
      case 'MONEY_TO_POINT':
        return Icons.currency_exchange;
      case 'MEMBER_SUBSCRIPTION':
        return Icons.card_membership;
      default:
        return Icons.payment;
    }
  }

  bool _isPositive(WalletTransaction tx) {
    return tx.direction == 'IN' || (tx.balanceChange ?? 0) > 0;
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();

    if (wallet.isLoading && wallet.transactions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (wallet.transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              "Chưa có giao dịch nào",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => wallet.refresh(context),
              icon: const Icon(Icons.refresh),
              label: const Text("Tải lại"),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => wallet.refresh(context),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: wallet.transactions.length,
        itemBuilder: (context, index) {
          final tx = wallet.transactions[index];

          final isPositive = _isPositive(tx);
          final amount = (tx.balanceChange ?? tx.amount ?? 0.0).abs();

          final currencyLabel = _currencyLabel(tx.currency);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),

              // ================= ICON =================
              leading: CircleAvatar(
                backgroundColor: _transactionColor(tx).withOpacity(0.12),
                child: Icon(_transactionIcon(tx), color: _transactionColor(tx)),
              ),

              // ================= TITLE =================
              title: Text(
                tx.description ?? "Giao dịch",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),

              // ================= SUBTITLE =================
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatDate(tx.createdAt),
                    style: const TextStyle(fontSize: 13),
                  ),

                  if (tx.status != null)
                    Text(
                      "Trạng thái: ${_statusText(tx.status)}",
                      style: TextStyle(color: _statusColor(tx.status)),
                    ),
                ],
              ),

              // ================= AMOUNT =================
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${isPositive ? '+' : '-'}${formatNumber(amount)}$currencyLabel",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
