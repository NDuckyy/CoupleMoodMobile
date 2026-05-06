import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:couple_mood_mobile/providers/voucher/voucher_list_provider.dart';
import 'package:couple_mood_mobile/widgets/voucher/animated_voucher_item.dart';
import 'package:couple_mood_mobile/widgets/voucher/voucher_card.dart';

class VoucherListScreen extends StatefulWidget {
  const VoucherListScreen({super.key});

  @override
  State<VoucherListScreen> createState() => _VoucherListScreenState();
}

class _VoucherListScreenState extends State<VoucherListScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    /// chạy sau frame đầu tiên (an toàn context)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initLoad();
    });
  }

  void _initLoad() {
    final provider = context.read<VoucherProvider>();

    if (!_initialized) {
      provider.fetchVouchers(refresh: true);
      _initialized = true;
    }
  }

  void _onScroll() {
    final provider = context.read<VoucherProvider>();

    if (!provider.hasMore || provider.isLoadingMore) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      provider.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<VoucherProvider>().fetchVouchers(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0FF),
      body: Consumer<VoucherProvider>(
        builder: (context, provider, _) {
          /// FIRST LOAD
          if (provider.isLoading && provider.vouchers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          /// ERROR
          if (provider.error != null && provider.vouchers.isEmpty) {
            return Center(child: Text(provider.error!));
          }

          /// EMPTY
          if (provider.vouchers.isEmpty) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(
                    child: Text(
                      "Không có voucher nào đang được phát hành",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: provider.vouchers.length + 1,
              itemBuilder: (context, index) {
                /// ITEM
                if (index < provider.vouchers.length) {
                  final v = provider.vouchers[index];

                  return AnimatedVoucherItem(
                    index: index,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () async {
                          if (provider.isExchanging(v.id)) return;
                          await context.pushNamed(
                            'voucher_detail',
                            extra: {'voucherId': v.id},
                          );

                          context.read<VoucherProvider>().fetchVouchers(
                            refresh: true,
                          );
                        },
                        child: VoucherCard(
                          key: ValueKey(v.id),
                          voucher: v,
                          isLoading: provider.isExchanging(v.id),
                          onExchange: () async {
                            await context
                                .read<VoucherProvider>()
                                .exchangeVoucher(context, v);
                          },
                        ),
                      ),
                    ),
                  );
                }

                /// LOAD MORE
                if (provider.isLoadingMore) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return const SizedBox();
              },
            ),
          );
        },
      ),
    );
  }
}
