import 'package:couple_mood_mobile/providers/voucher/my_voucher_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

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

    final v = provider.voucherDetail;

    if (v == null) {
      return const Scaffold(body: Center(child: Text("Không có dữ liệu")));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(title: Text(v.voucherTitle)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                /// 🎟 HEADER CARD (giống bên kia)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFB388EB), Color(0xFF8093F1)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v.voucherTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// DISCOUNT
                      Text(
                        v.discountType == "PERCENTAGE"
                            ? "-${v.discountPercent?.toStringAsFixed(0)}%"
                            : "-${v.discountAmount}",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "HSD: ${v.expiredAt.day}/${v.expiredAt.month}/${v.expiredAt.year}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// QR CARD
                _card(
                  child: Column(
                    children: [
                      Image.network(v.qrCodeUrl, height: 180),
                      const SizedBox(height: 12),
                      SelectableText(
                        v.itemCode,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// DESCRIPTION
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Chi tiết",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(v.voucherDescription ?? "Không có mô tả"),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// LOCATION
                if (v.locations.isNotEmpty)
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Áp dụng tại",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...v.locations.map((loc) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.store),
                            title: Text(loc.venueLocationName),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            ),
                            onTap: () {
                              context.pushNamed(
                                'venue_detail',
                                extra: {'venueId': loc.venueLocationId},
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
