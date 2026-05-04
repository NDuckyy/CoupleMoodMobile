import 'package:couple_mood_mobile/providers/subscription/subscription_provider.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:couple_mood_mobile/widgets/subscription/subscription_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isYearly = true;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<SubscriptionProvider>().fetchAll();
    });

    _controller =
        VideoPlayerController.asset("lib/assets/images/subscription_vid.mp4")
          ..setLooping(true)
          ..setVolume(0)
          ..initialize().then((_) {
            if (mounted) {
              setState(() {});
              _controller.play();
            }
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubscriptionProvider>();

    if (provider.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final packages = provider.packages;
    final selectedPkg = packages.firstWhere(
      (p) => !p.isFree && p.isYearly == _isYearly,
    );

    final monthlyPkg = packages.firstWhere((p) => !p.isFree && !p.isYearly);
    final yearlyPkg = packages.firstWhere((p) => !p.isFree && p.isYearly);

    final benefits = [
      "Không quảng cáo - trải nghiệm mượt mà",
      "Bản đồ tình yêu & theo dõi vị trí",
      "AI gợi ý kế hoạch hẹn hò",
    ];

    Widget _buildCTA() {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            final confirm = await _confirmBuy(context, selectedPkg.packageName);
            if (!confirm) return;

            final method = await _selectPaymentMethod(context);
            if (method == null) return;

            final success = await context
                .read<SubscriptionProvider>()
                .buyPackage(context, selectedPkg.id, method);

            if (!context.mounted) return;

            showMsg(
              context,
              success ? "Đang chuyển tới thanh toán 💳" : "Thanh toán thất bại",
              success,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF9C27B0),
            elevation: 6,
            shadowColor: Colors.black.withOpacity(0.25),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            "Nâng cấp ngay 💜",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          /// BG IMAGE
          Positioned.fill(
            child: _controller.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : const SizedBox(),
          ),

          /// GRADIENT
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.75),
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          /// CONTENT
          Column(
            children: [
              const SizedBox(height: 60),

              /// TITLE + FEATURES
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Text(
                      "Nâng cấp tình yêu 💜",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Mở khóa trải nghiệm tốt hơn cho cả hai",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),

                    const SizedBox(height: 10),

                    ...benefits.map(
                      (b) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.check, color: Colors.white),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                b,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: Column(
                  children: [
                    /// PLAN CARDS
                    SubscriptionCard(
                      pkg: monthlyPkg,
                      selected: !_isYearly,
                      disabled: !provider.canSelect(monthlyPkg),
                      isCurrent: provider.isCurrent(monthlyPkg.id),
                      onTap: () => setState(() => _isYearly = false),
                    ),

                    SubscriptionCard(
                      pkg: yearlyPkg,
                      selected: _isYearly,
                      disabled: !provider.canSelect(yearlyPkg),
                      isCurrent: provider.isCurrent(yearlyPkg.id),
                      onTap: () => setState(() => _isYearly = true),
                    ),

                    const SizedBox(height: 20),

                    /// CTA
                    _buildCTA(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<PaymentMethod?> _selectPaymentMethod(BuildContext context) async {
  return showModalBottomSheet<PaymentMethod>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text(
              "Chọn phương thức thanh toán",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text("MoMo"),
              onTap: () => Navigator.pop(context, PaymentMethod.momo),
            ),

            ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text("ZaloPay"),
              onTap: () => Navigator.pop(context, PaymentMethod.zalopay),
            ),

            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text("VNPay"),
              onTap: () => Navigator.pop(context, PaymentMethod.vnpay),
            ),

            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
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
