import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:couple_mood_mobile/providers/voucher/member_voucher_provider.dart';

class MemberVoucherScreen extends StatefulWidget {
  const MemberVoucherScreen({super.key});

  @override
  State<MemberVoucherScreen> createState() => _MemberVoucherScreenState();
}

class _MemberVoucherScreenState extends State<MemberVoucherScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MemberVoucherProvider>(
        context,
        listen: false,
      );
      provider.fetchVouchers();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = Provider.of<MemberVoucherProvider>(context, listen: false);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mã khuyến mãi")),
      body: Consumer<MemberVoucherProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.vouchers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchVouchers(refresh: true),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: provider.vouchers.length + 1,
              itemBuilder: (context, index) {
                if (index < provider.vouchers.length) {
                  final v = provider.vouchers[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      title: Text(v.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            v.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Giảm: ${v.discountAmount ?? v.discountPercent}",
                          ),
                          Text("Còn lại: ${v.remainingQuantity}"),
                        ],
                      ),
                    ),
                  );
                }

                /// loading more indicator
                return provider.isLoadingMore
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox();
              },
            ),
          );
        },
      ),
    );
  }
}
