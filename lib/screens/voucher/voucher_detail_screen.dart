import 'package:couple_mood_mobile/providers/voucher/voucher_detail_provider.dart';
import 'package:couple_mood_mobile/utils/currency_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class VoucherDetailScreen extends StatefulWidget {
  final int voucherId;

  const VoucherDetailScreen({super.key, required this.voucherId});

  @override
  State<VoucherDetailScreen> createState() => _VoucherDetailScreenState();
}

class _VoucherDetailScreenState extends State<VoucherDetailScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<VoucherDetailProvider>().fetchDetail(widget.voucherId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chi tiết voucher")),
      body: Consumer<VoucherDetailProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          final v = provider.voucher;
          if (v == null) {
            return const Center(child: Text("Không có dữ liệu"));
          }

          final locations = v.locations;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              /// TITLE
              Text(
                v.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              /// DESCRIPTION
              Text(v.description ?? ""),

              const SizedBox(height: 16),

              /// DISCOUNT
              Text(
                "Giảm: ${CurrencyUtils.formatVND(v.discountAmount ?? 0)}",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// 🔥 LOCATION LIST
              const Text(
                "Áp dụng tại:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              ...locations.map((loc) {
                return ListTile(
                  leading: const Icon(Icons.store),
                  title: Text(loc.venueLocationName),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                  /// CLICK → GO TO VENUE
                  onTap: () {
                    context.pushNamed(
                      'venue_detail',
                      extra: {'venueId': loc.venueLocationId},
                    );
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
