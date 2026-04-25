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
  String formatVND(num amount) => NumberFormat('#,###', 'vi_VN').format(amount);

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy HH:mm').format(date.toLocal());
  }

  Color _getTransactionColor(WalletTransaction tx) {
    if (tx.transactionType == 'WALLET_TOPUP') return Colors.green;
    if (tx.transactionType == 'MONEY_TO_POINT') return Colors.orange;
    return Colors.blue;
  }

  IconData _getTransactionIcon(WalletTransaction tx) {
    if (tx.transactionType == 'WALLET_TOPUP') return Icons.add_circle_outline;
    if (tx.transactionType == 'MONEY_TO_POINT') return Icons.currency_exchange;
    return Icons.payment;
  }

  bool _isPositive(WalletTransaction tx) {
    return tx.direction == 'IN' || (tx.balanceChange ?? 0) > 0;
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();

    // Debug log
    print(
      'TransactionsTab rebuild → isLoading: ${wallet.isLoading}, count: ${wallet.transactions.length}',
    );

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
          final amount =
              tx.balanceChange ??
              tx.amount ??
              0.0; // ← Dùng num vì API trả float

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
              leading: CircleAvatar(
                backgroundColor: _getTransactionColor(tx).withOpacity(0.12),
                child: Icon(
                  _getTransactionIcon(tx),
                  color: _getTransactionColor(tx),
                ),
              ),
              title: Text(
                tx.description ?? "Giao dịch",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatDate(tx.createdAt),
                    style: const TextStyle(fontSize: 13),
                  ),
                  if (tx.status != null)
                    Text(
                      "Trạng thái: ${tx.status}",
                      style: TextStyle(
                        color: tx.status == "SUCCESS"
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                ],
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${isPositive ? '+' : '-'}${formatVND(amount.abs())}đ",
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
