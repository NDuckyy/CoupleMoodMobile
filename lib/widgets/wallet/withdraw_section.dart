import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet/wallet_provider.dart';
import 'withdraw_button.dart';
import 'withdrawal_history_list.dart';

class WithdrawSection extends StatelessWidget {
  final ColorScheme colorScheme;
  const WithdrawSection({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rút tiền về ngân hàng",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        WithdrawButton(colorScheme: colorScheme),
        const SizedBox(height: 24),

        Text(
          "Lịch sử rút tiền",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        WithdrawalHistoryList(
          requests: wallet.withdrawRequests,
          isLoading: wallet.isLoading,
        ),
      ],
    );
  }
}
