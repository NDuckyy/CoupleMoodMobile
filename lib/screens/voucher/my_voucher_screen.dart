import 'package:couple_mood_mobile/providers/voucher/my_voucher_provider.dart';
import 'package:couple_mood_mobile/widgets/voucher/animated_voucher_item.dart';
import 'package:couple_mood_mobile/widgets/voucher/my_voucher_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MyVoucherScreen extends StatefulWidget {
  const MyVoucherScreen({super.key});

  @override
  State<MyVoucherScreen> createState() => _MyVoucherScreenState();
}

class _MyVoucherScreenState extends State<MyVoucherScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load lần đầu tiên
    if (!_initialized) {
      context.read<MyVoucherProvider>().fetchMyVouchers(refresh: true);
      _initialized = true;
    }
  }

  Future<void> _onRefresh() async {
    await context.read<MyVoucherProvider>().fetchMyVouchers(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MyVoucherProvider>();

    return Scaffold(
      body: provider.loading && provider.vouchers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : provider.vouchers.isEmpty
          ? RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(
                    child: Text(
                      "Không có voucher nào",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: provider.vouchers.length,
                itemBuilder: (context, index) {
                  final voucher = provider.vouchers[index];
                  return AnimatedVoucherItem(
                    index: index,
                    child: MyVoucherCard(
                      voucher: voucher,
                      onTap: () async {
                        await context.pushNamed(
                          'my_voucher_detail',
                          extra: {'voucherItemId': voucher.voucherItemId},
                        );

                        // reload khi pop về
                        if (mounted) {
                          await context
                              .read<MyVoucherProvider>()
                              .fetchMyVouchers(refresh: true);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
