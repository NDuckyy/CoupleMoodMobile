import 'package:flutter/material.dart';
import 'package:couple_mood_mobile/providers/wallet/wallet_provider.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';

class PaymentMethodBottomSheet extends StatelessWidget {
  final WalletProvider wallet;
  final int amount;

  const PaymentMethodBottomSheet({
    super.key,
    required this.wallet,
    required this.amount,
  });

  static void show(BuildContext context, WalletProvider wallet, int amount) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => PaymentMethodBottomSheet(wallet: wallet, amount: amount),
    );
  }

  Future<void> _handle(
    BuildContext context,
    PaymentMethod method,
    String name,
  ) async {
    Navigator.pop(context);

    final success = await wallet.topup(context, amount, method);

    if (!context.mounted) return;

    if (success) {
      showMsg(context, "Đang mở $name...", true);
    } else {
      showMsg(context, wallet.error ?? "Lỗi", false);
    }
  }

  Widget _tile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required PaymentMethod method,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => _handle(context, method, title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Chọn phương thức thanh toán",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          _tile(
            context: context,
            icon: Icons.account_balance_wallet,
            title: "MoMo",
            method: PaymentMethod.momo,
          ),

          _tile(
            context: context,
            icon: Icons.qr_code,
            title: "ZaloPay",
            method: PaymentMethod.zalopay,
          ),

          _tile(
            context: context,
            icon: Icons.language,
            title: "VNPay",
            method: PaymentMethod.vnpay,
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
