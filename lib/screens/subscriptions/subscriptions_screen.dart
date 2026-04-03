import 'package:couple_mood_mobile/providers/subscription/subscription_provider.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:couple_mood_mobile/widgets/subscription/subscription_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isYearlySelected = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SubscriptionProvider>().fetchAll());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubscriptionProvider>();

    if (provider.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final packages = provider.packages;
    final freePkg = packages.where((p) => p.isFree).firstOrNull;
    final premiumPkgs = packages
        .where((p) => !p.isFree && (p.isYearly == _isYearlySelected))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nâng cấp tài khoản"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF8F5FF),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F5FF), Color(0xFFF5F6FA)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 40),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Chọn gói phù hợp cho tình yêu của bạn 💜",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Mở khóa trải nghiệm tuyệt vời hơn cho cả hai",
                    style: TextStyle(fontSize: 15.5, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Tab
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isYearlySelected = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: !_isYearlySelected
                                ? const Color(0xFF9C27B0)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              "GÓI THÁNG",
                              style: TextStyle(
                                color: !_isYearlySelected
                                    ? Colors.white
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isYearlySelected = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _isYearlySelected
                                ? const Color(0xFF9C27B0)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              "GÓI NĂM",
                              style: TextStyle(
                                color: _isYearlySelected
                                    ? Colors.white
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Premium Card
            if (premiumPkgs.isNotEmpty)
              SubscriptionCard(
                pkg: premiumPkgs.first,
                isHighlighted: _isYearlySelected,
                isLoading:
                    provider.isPaying &&
                    provider.selectedPackageId == premiumPkgs.first.id,
                isActive: provider.isCurrentPackage(premiumPkgs.first.id),
                onBuy: () async {
                  final confirm = await _confirmBuy(
                    context,
                    premiumPkgs.first.packageName,
                  );
                  if (!confirm) return;
                  final success = await context
                      .read<SubscriptionProvider>()
                      .buyPackage(premiumPkgs.first.id);
                  if (!context.mounted) return;
                  showMsg(
                    context,
                    success
                        ? "Đang chuyển tới thanh toán 💳"
                        : "Thanh toán thất bại",
                    success,
                  );
                },
              ),

            const SizedBox(height: 40),

            // Free Card
            if (freePkg != null)
              SubscriptionCard(
                pkg: freePkg,
                isHighlighted: false,
                isActive: true,
              ),
          ],
        ),
      ),
    );
  }
}

Future<bool> _confirmBuy(BuildContext context, String name) async {
  return await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Xác nhận mua gói"),
          content: Text("Bạn muốn mua gói \"$name\" không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Đồng ý"),
            ),
          ],
        ),
      ) ??
      false;
}
