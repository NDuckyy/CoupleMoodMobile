import 'package:flutter/material.dart';
import 'package:couple_mood_mobile/utils/currency_utils.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet/wallet_provider.dart';
import 'payment_method_bottom_sheet.dart';

class TopupSection extends StatefulWidget {
  final ColorScheme colorScheme;

  const TopupSection({super.key, required this.colorScheme});

  @override
  State<TopupSection> createState() => _TopupSectionState();
}

class _TopupSectionState extends State<TopupSection> {
  final TextEditingController _amountCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final colorScheme = widget.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// nạp nhanh
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
                onTap: () {
                  final text = CurrencyUtils.formatRaw(amt);
                  _amountCtrl.value = TextEditingValue(
                    text: text,
                    selection: TextSelection.collapsed(offset: text.length),
                  );
                },
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

        const SizedBox(height: 32),

        /// nhập tiền
        const Text(
          "Nhập số tiền nạp",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),

        Form(
          key: _formKey,
          child: TextFormField(
            controller: _amountCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [VNDInputFormatter()],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
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
              final amount = CurrencyUtils.parseVND(value ?? '');

              if ((value ?? '').trim().isEmpty) {
                return "Vui lòng nhập số tiền";
              }
              if (amount < 1000) {
                return "Tối thiểu 1.000đ";
              }
              if (amount > 100000000) {
                return "Tối đa 100.000.000đ";
              }
              return null;
            },
          ),
        ),

        const SizedBox(height: 28),

        /// nạp
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
                  : () {
                      if (!_formKey.currentState!.validate()) return;

                      final amount = CurrencyUtils.parseVND(_amountCtrl.text);

                      PaymentMethodBottomSheet.show(context, wallet, amount);
                    },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
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
                            Icon(Icons.payment, color: Colors.white, size: 26),
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
      ],
    );
  }
}
