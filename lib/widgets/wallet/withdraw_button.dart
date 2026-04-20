import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet/wallet_provider.dart';
import 'withdraw_bottom_sheet.dart';

class WithdrawButton extends StatelessWidget {
  final ColorScheme colorScheme;
  const WithdrawButton({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 68,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showWithdrawBottomSheet(context),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  "Rút tiền về ngân hàng",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showWithdrawBottomSheet(BuildContext context) async {
    final walletProvider = context.read<WalletProvider>();

    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: walletProvider,
        child: WithdrawBottomSheet(
          colorScheme: colorScheme,
          walletProvider: walletProvider,
        ),
      ),
    );

    if (result == true) {
      //  reload ở đây (an toàn)
      await walletProvider.loadWalletData(context);

      showMsg(context, "Yêu cầu rút tiền đã được tạo thành công!", true);
    }
  }
}
