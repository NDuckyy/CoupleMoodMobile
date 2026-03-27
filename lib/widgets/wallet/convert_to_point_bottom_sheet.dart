import 'package:couple_mood_mobile/models/wallet/exchange_rate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet/wallet_provider.dart';
import '../../widgets/snack_bar.dart';

class ConvertToPointBottomSheet extends StatefulWidget {
  final ColorScheme colorScheme;
  const ConvertToPointBottomSheet({super.key, required this.colorScheme});

  static Future<void> show(BuildContext context, ColorScheme colorScheme) {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => ChangeNotifierProvider.value(
        value: walletProvider,
        child: ConvertToPointBottomSheet(colorScheme: colorScheme),
      ),
    );
  }

  @override
  State<ConvertToPointBottomSheet> createState() =>
      _ConvertToPointBottomSheetState();
}

class _ConvertToPointBottomSheetState extends State<ConvertToPointBottomSheet> {
  final _amountCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _amountCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  String formatVND(num amount) => NumberFormat('#,###', 'vi_VN').format(amount);

  int getPointsFromAmount(num amount, ExchangeRate? rate) {
    if (rate == null || rate.moneyAmount == 0) return 0;
    return (amount / rate.moneyAmount).floor() * rate.pointAmount;
  }

  num get currentAmount {
    final text = _amountCtrl.text
        .replaceAll('.', '')
        .replaceAll('đ', '')
        .trim();
    return num.tryParse(text) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final rate = wallet.exchangeRate;
    final moneyBalance = wallet.moneyBalance.toDouble();
    final pointsNow = wallet.pointsBalance;

    final amount = currentAmount;
    final pointsWillGet = getPointsFromAmount(amount, rate);
    final pointsAfter = pointsNow + pointsWillGet;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Đổi tiền sang điểm",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              rate != null
                  ? "Tỉ lệ: ${rate.moneyAmount} VND = ${rate.pointAmount} Point"
                  : "Đang tải tỉ lệ...",
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                prefixText: "đ ",
                prefixStyle: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: widget.colorScheme.primary,
                ),
                hintText: "0",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (v) {
                final val = num.tryParse(
                  (v ?? '').replaceAll('.', '').replaceAll('đ', '').trim(),
                );
                if (val == null || val < 1000) return "Tối thiểu 1.000đ";
                if (val > moneyBalance) return "Không đủ số dư";
                return null;
              },
            ),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _amountCtrl.text = formatVND(moneyBalance),
                icon: const Icon(Icons.all_inclusive, size: 18),
                label: const Text("Đổi hết số dư"),
              ),
            ),

            const SizedBox(height: 24),

            // Preview
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Điểm hiện tại"),
                      Text(
                        formatVND(pointsNow),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Điểm nhận được"),
                      Text(
                        "+ ${formatVND(pointsWillGet)}",
                        style: TextStyle(
                          color: widget.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Tổng điểm sau đổi",
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        formatVND(pointsAfter),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: widget.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 62,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 3,
                ),
                onPressed: wallet.isLoadingConvert
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;

                        final raw = _amountCtrl.text
                            .replaceAll('.', '')
                            .replaceAll('đ', '')
                            .trim();
                        final amountToConvert = int.tryParse(raw) ?? 0;

                        final success = await wallet.convertMoneyToPoint(
                          amountToConvert,
                          context,
                        );

                        if (success) {
                          Navigator.pop(context); // Đóng sheet
                          showMsg(
                            context,
                            "Đổi thành công! +${formatVND(pointsWillGet)} points",
                            true,
                          );
                        } else {
                          showMsg(
                            context,
                            wallet.error ?? "Đổi thất bại",
                            false,
                          );
                        }
                      },
                child: wallet.isLoadingConvert
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Xác nhận đổi",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
