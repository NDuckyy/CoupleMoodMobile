import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet/wallet_provider.dart';
import '../../utils/currency_utils.dart';
import '../../widgets/snack_bar.dart';
import 'convert_to_point_bottom_sheet.dart';

class MoneyWalletTab extends StatefulWidget {
  final ColorScheme colorScheme;
  const MoneyWalletTab({super.key, required this.colorScheme});

  @override
  State<MoneyWalletTab> createState() => _MoneyWalletTabState();
}

class _MoneyWalletTabState extends State<MoneyWalletTab> {
  final TextEditingController _amountCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isBalanceVisible = false;

  String formatVND(int amount) => NumberFormat('#,###', 'vi_VN').format(amount);

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final colorScheme = widget.colorScheme; // Nhận từ Hub

    return CustomScrollView(
      slivers: [
        // === Ví 3D Hero - Giữ nguyên thiết kế cũ ===
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.surface,
                    colorScheme.primary,
                    colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.45),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 25,
                    offset: const Offset(10, 20),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 1.5,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Số dư ví tiền",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 4),
                              ],
                            ),
                            IconButton(
                              onPressed: () => setState(
                                () => _isBalanceVisible = !_isBalanceVisible,
                              ),
                              icon: Icon(
                                _isBalanceVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _isBalanceVisible
                              ? "${formatVND(wallet.moneyBalance)}đ"
                              : "••••••• đ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _isBalanceVisible ? 36 : 32,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Nạp nhanh
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Nạp nhanh",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [50000, 100000, 200000, 500000].map((amt) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _amountCtrl.text = formatVND(amt),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: colorScheme.primary.withOpacity(0.25),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "${(amt ~/ 1000)}k",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),

        // Form nạp + Nút đổi điểm
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Nhập số tiền nạp",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _amountCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [VNDInputFormatter()],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      prefixText: "đ ",
                      prefixStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                      hintText: "0",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                    ),
                    validator: (value) {
                      final raw = (value ?? '')
                          .replaceAll('.', '')
                          .replaceAll('đ', '')
                          .trim();
                      final amount = int.tryParse(raw);
                      if (raw.isEmpty) return "Vui lòng nhập số tiền";
                      if (amount == null || amount < 1000)
                        return "Tối thiểu 1.000đ";
                      return null;
                    },
                  ),

                  const SizedBox(height: 28),

                  // Nút Nạp tiền qua MoMo
                  SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: Material(
                      color: Colors.transparent,
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onTap: wallet.isLoading
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;

                                final raw = _amountCtrl.text
                                    .replaceAll('.', '')
                                    .replaceAll('đ', '')
                                    .trim();
                                final amount = int.parse(raw);

                                _showPaymentMethod(context, wallet, amount);
                              },
                        borderRadius: BorderRadius.circular(20),
                        splashColor: Colors.white.withOpacity(0.25),
                        highlightColor: Colors.white.withOpacity(0.15),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primary,
                                colorScheme.secondary,
                              ],
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
                          child: Center(
                            child: wallet.isLoading
                                ? const SizedBox(
                                    height: 28,
                                    width: 28,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3.5,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.payment,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        "Nạp tiền",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Nút Đổi tiền sang điểm
                  SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: OutlinedButton(
                      onPressed: () =>
                          ConvertToPointBottomSheet.show(context, colorScheme),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colorScheme.primary, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.currency_exchange,
                            color: colorScheme.primary,
                            size: 26,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Đổi tiền sang điểm",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

void _showPaymentMethod(
  BuildContext context,
  WalletProvider wallet,
  int amount,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
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

            /// MOMO
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text("MoMo"),
              onTap: () async {
                Navigator.pop(context);

                final success = await wallet.topup(amount, PaymentMethod.momo);

                if (success) {
                  showMsg(context, "Đang mở MoMo...", true);
                } else {
                  showMsg(context, wallet.error ?? "Lỗi", false);
                }
              },
            ),

            /// ZALOPAY
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text("ZaloPay"),
              onTap: () async {
                Navigator.pop(context);

                final success = await wallet.topup(
                  amount,
                  PaymentMethod.zalopay,
                );

                if (success) {
                  showMsg(context, "Đang mở ZaloPay...", true);
                } else {
                  showMsg(context, wallet.error ?? "Lỗi", false);
                }
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
