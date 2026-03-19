import 'package:couple_mood_mobile/providers/voucher/my_voucher_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyVoucherDetailScreen extends StatefulWidget {
  final int voucherItemId;

  const MyVoucherDetailScreen({super.key, required this.voucherItemId});

  @override
  State<MyVoucherDetailScreen> createState() => _MyVoucherDetailScreenState();
}

class _MyVoucherDetailScreenState extends State<MyVoucherDetailScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<MyVoucherDetailProvider>().fetchVoucherDetail(
        widget.voucherItemId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MyVoucherDetailProvider>();

    if (provider.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final voucher = provider.voucherDetail;

    if (voucher == null) {
      return const Scaffold(body: Center(child: Text("Không có dữ liệu")));
    }

    return Scaffold(
      appBar: AppBar(title: Text(voucher.voucherTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Image.network(voucher.qrCodeUrl, height: 200),
            const SizedBox(height: 16),
            SelectableText(
              voucher.itemCode,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 24),
            Text(voucher.voucherDescription ?? ""),
          ],
        ),
      ),
    );
  }
}
