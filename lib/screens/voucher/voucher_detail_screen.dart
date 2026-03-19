import 'package:couple_mood_mobile/providers/voucher/voucher_detail_provider.dart';
import 'package:couple_mood_mobile/utils/currency_utils.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
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
      backgroundColor: const Color(0xFFF5F6FA),
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

          /// trạng thái
          final isOutOfStock = v.remainingQuantity <= 0;
          final isExpired = v.endDate.isBefore(DateTime.now());

          return Column(
            children: [
              /// CONTENT
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    /// 🔥 HEADER CARD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFB388EB), Color(0xFF8093F1)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            v.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 12),

                          /// DISCOUNT
                          Text(
                            CurrencyUtils.formatVND(v.discountAmount ?? 0),
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// POINT + STOCK
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.stars, color: Colors.yellow),
                                  const SizedBox(width: 6),
                                  Text(
                                    "${v.pointPrice} điểm",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                "Còn ${v.remainingQuantity}",
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
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
                            "Mô tả",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(v.description ?? ""),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// LOCATION
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

                    const SizedBox(height: 20),

                    /// trạng thái
                    if (isOutOfStock)
                      const Text(
                        "Đã hết hàng",
                        style: TextStyle(color: Colors.red),
                      ),
                    if (isExpired)
                      const Text(
                        "Voucher đã hết hạn",
                        style: TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
              ),

              /// CTA BUTTON FIXED
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          (provider.isExchanging || isOutOfStock || isExpired)
                          ? null
                          : () async {
                              final success = await context
                                  .read<VoucherDetailProvider>()
                                  .exchangeVoucher();

                              if (!context.mounted) return;

                              if (success) {
                                showMsg(
                                  context,
                                  "Đổi voucher thành công 💜",
                                  true,
                                );

                                /// reload lại
                                context
                                    .read<VoucherDetailProvider>()
                                    .fetchDetail(widget.voucherId);
                              } else {
                                showMsg(
                                  context,
                                  provider.error ?? "Đổi voucher thất bại",
                                  false,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB388EB),
                        disabledBackgroundColor: Colors.grey.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: provider.isExchanging
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "ĐỔI VOUCHER NGAY",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// reusable card
  Widget _card({required Widget child}) {
    return Container(
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
