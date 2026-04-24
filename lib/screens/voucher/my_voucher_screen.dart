import 'package:couple_mood_mobile/providers/voucher/my_voucher_provider.dart';
import 'package:couple_mood_mobile/widgets/voucher/animated_voucher_item.dart';
import 'package:couple_mood_mobile/widgets/voucher/my_voucher_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class MyVoucherScreen extends StatefulWidget {
  const MyVoucherScreen({super.key});

  @override
  State<MyVoucherScreen> createState() => _MyVoucherScreenState();
}

class _MyVoucherScreenState extends State<MyVoucherScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  final List<Map<String, String>> _tabs = [
    {"key": "ALL", "label": "Tất cả"},
    {"key": "ACQUIRED", "label": "Sẵn sàng"},
    {"key": "USED", "label": "Đã dùng"},
    {"key": "EXPIRED", "label": "Hết hạn"},
  ];

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) return;

    final provider = context.read<MyVoucherProvider>();
    final newStatus = _tabs[_tabController.index]["key"]!;

    if (provider.status != newStatus) {
      provider.setStatus(newStatus);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<MyVoucherProvider>().fetchMyVouchers(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MyVoucherProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          // === SEARCH BAR ===
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Tìm theo tên hoặc mã voucher...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF7E57C2)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          provider.setKeyword(null);
                          provider.search();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onSubmitted: (value) {
                provider.setKeyword(value);
                provider.search();
              },
            ),
          ),

          // === TAB STATUS - ĐÃ SỬA (Scrollable + Animation mượt) ===
          Container(
            height: 52,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true, // ← Quan trọng: Cho phép cuộn
              tabAlignment: TabAlignment.start, // Căn trái khi scrollable
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0xFF7E57C2),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey.shade700,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.5,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.5,
              ),
              labelPadding: const EdgeInsets.symmetric(
                horizontal: 20,
              ), // ← Tăng padding để chữ không bị che
              tabs: _tabs.map((tab) => Tab(text: tab["label"])).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // === DANH SÁCH VOUCHER (ĐÃ BỌC AnimatedVoucherItem) ===
          Expanded(
            child: provider.loading && provider.vouchers.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: provider.vouchers.isEmpty
                        ? ListView(
                            children: const [
                              SizedBox(height: 150),
                              Center(
                                child: Text(
                                  "Không có voucher nào",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
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
                                      extra: {
                                        'voucherItemId': voucher.voucherItemId,
                                      },
                                    );

                                    // Reload sau khi quay về
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
          ),
        ],
      ),
    );
  }
}
