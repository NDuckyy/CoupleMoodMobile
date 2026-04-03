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
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SubscriptionProvider>().fetchPackages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubscriptionProvider>();

    if (provider.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Nâng cấp tài khoản")),
      backgroundColor: const Color(0xFFF5F6FA),
      body: Builder(
        builder: (context) {
          final packages = provider.packages;

          final freePkg = packages.where((p) => p.isFree).cast().toList();

          final premiumPkgs = packages.where((p) => !p.isFree).toList();

          return ListView(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            children: [
              const SizedBox(height: 10),

              /// HEADER
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Chọn gói phù hợp 💜",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),

              /// ================= FREE =================
              if (freePkg.isNotEmpty)
                SubscriptionCard(pkg: freePkg.first, highlight: false),

              /// ================= PREMIUM =================
              if (premiumPkgs.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Nâng cấp Premium 🚀",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                ...premiumPkgs.map((pkg) {
                  return SubscriptionCard(
                    pkg: pkg,
                    highlight: pkg.isYearly,
                    isLoading:
                        provider.isPaying &&
                        provider.selectedPackageId == pkg.id,
                    onBuy: () async {
                      final confirm = await _confirmBuy(
                        context,
                        pkg.packageName,
                      );
                      if (!confirm) return;

                      final success = await context
                          .read<SubscriptionProvider>()
                          .buyPackage(pkg.id);

                      if (!context.mounted) return;

                      showMsg(
                        context,
                        success
                            ? "Đang chuyển tới thanh toán 💳"
                            : "Thanh toán thất bại",
                        success,
                      );
                    },
                  );
                }),
              ],
            ],
          );
        },
      ),
    );
  }
}

Future<bool> _confirmBuy(BuildContext context, String name) async {
  return await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Xác nhận"),
          content: Text("Bạn muốn mua gói \"$name\" không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Mua"),
            ),
          ],
        ),
      ) ??
      false;
}
