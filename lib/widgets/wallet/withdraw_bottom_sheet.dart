import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet/wallet_provider.dart';
import '../../models/wallet/withdraw_request.dart';
import '../../utils/currency_utils.dart';

class WithdrawBottomSheet extends StatefulWidget {
  final ColorScheme colorScheme;
  final WalletProvider walletProvider;

  const WithdrawBottomSheet({
    super.key,
    required this.colorScheme,
    required this.walletProvider,
  });

  @override
  State<WithdrawBottomSheet> createState() => _WithdrawBottomSheetState();
}

class _WithdrawBottomSheetState extends State<WithdrawBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final bankNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final accountNameController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    bankNameController.dispose();
    accountNumberController.dispose();
    accountNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final isLoading = wallet.isLoading;
    final sheetColor = Theme.of(context).colorScheme.surface;

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: bottomInset > 0 ? bottomInset * 0.6 : 0,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: sheetColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rút tiền về ngân hàng",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Số dư hiện tại: ${CurrencyUtils.formatVND(wallet.moneyBalance)}",
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ==================== SỐ TIỀN RÚT (đã giống Topup) ====================
                  Text(
                    "Số tiền rút (VND)",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [VNDInputFormatter()],
                    validator: (v) {
                      final raw = (v ?? '')
                          .replaceAll('.', '')
                          .replaceAll('đ', '')
                          .trim();

                      final val = int.tryParse(raw);

                      if (val == null || val == 0) return "Nhập số tiền";
                      if (val < 1000) return "Tối thiểu 1.000đ";
                      if (val > context.read<WalletProvider>().moneyBalance) {
                        return "Không đủ số dư";
                      }

                      return null;
                    },
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      prefixText: "đ ",
                      prefixStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: widget.colorScheme.primary,
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
                  ),
                  const SizedBox(height: 24),

                  // Tên ngân hàng
                  TextFormField(
                    controller: bankNameController,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return "Nhập tên ngân hàng";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Tên ngân hàng",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Số tài khoản
                  TextFormField(
                    controller: accountNumberController,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final value = v?.trim() ?? "";

                      if (value.isEmpty) return "Nhập số tài khoản";
                      if (value.length < 6) return "Số tài khoản không hợp lệ";

                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Số tài khoản",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tên chủ tài khoản
                  TextFormField(
                    controller: accountNameController,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return "Nhập tên chủ tài khoản";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Tên chủ tài khoản",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Nút xác nhận
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;

                              final raw = amountController.text
                                  .replaceAll('.', '')
                                  .replaceAll('đ', '')
                                  .trim();
                              final amount = int.tryParse(raw) ?? 0;

                              final success = await context
                                  .read<WalletProvider>()
                                  .requestWithdraw(
                                    amount: amount,
                                    bankInfo: BankInfo(
                                      bankName: bankNameController.text.trim(),
                                      accountNumber: accountNumberController
                                          .text
                                          .trim(),
                                      accountName: accountNameController.text
                                          .trim(),
                                    ),
                                    context: context,
                                  );

                              if (!mounted) return;

                              if (success) {
                                Navigator.pop(context, true);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "XÁC NHẬN RÚT TIỀN",
                              style: TextStyle(
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
          ),
        ),
      ),
    );
  }
}
