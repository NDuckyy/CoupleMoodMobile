import 'package:couple_mood_mobile/widgets/wallet/withdraw_section.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet/wallet_provider.dart';
import 'convert_to_point_button.dart';
import 'topup_section.dart';

class MoneyWalletTab extends StatefulWidget {
  final ColorScheme colorScheme;
  const MoneyWalletTab({super.key, required this.colorScheme});

  @override
  State<MoneyWalletTab> createState() => _MoneyWalletTabState();
}

class _MoneyWalletTabState extends State<MoneyWalletTab> {
  bool _isBalanceVisible = false;

  String formatVND(int amount) => NumberFormat('#,###', 'vi_VN').format(amount);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final colorScheme = widget.colorScheme; // Nhận từ Hub

    return CustomScrollView(
      slivers: [
        // === Ví 3D Hero  ===
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

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                TopupSection(colorScheme: colorScheme),

                const SizedBox(height: 16),

                ConvertToPointButton(colorScheme: colorScheme),
                const SizedBox(height: 16),
                WithdrawSection(colorScheme: colorScheme),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
