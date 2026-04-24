import 'package:couple_mood_mobile/providers/voucher/my_voucher_provider.dart';
import 'package:couple_mood_mobile/providers/voucher/voucher_list_provider.dart';
import 'package:couple_mood_mobile/screens/voucher/my_voucher_screen.dart';
import 'package:couple_mood_mobile/screens/voucher/voucher_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VoucherHubScreen extends StatefulWidget {
  final int initialTab;

  const VoucherHubScreen({super.key, this.initialTab = 0});

  @override
  State<VoucherHubScreen> createState() => _VoucherHubScreenState();
}

class _VoucherHubScreenState extends State<VoucherHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, 1),
    );

    _tabController.addListener(_onTabChanged);

    /// load lần đầu (sau khi widget build xong → context OK)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleTabChange();
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;

    _handleTabChange();
    setState(() {}); // update title
  }

  void _handleTabChange() {
    final index = _tabController.index;

    if (index == 0) {
      context.read<VoucherProvider>().fetchVouchers(refresh: true);
    } else {
      final provider = context.read<MyVoucherProvider>();

      if (provider.status != "ALL") {
        provider.setStatus("ALL");
      }

      provider.fetchMyVouchers(refresh: true);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          _tabController.index == 0 ? "Mã khuyến mãi" : "Voucher của tôi",
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Khám phá"),
            Tab(text: "Của tôi"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [VoucherListScreen(), MyVoucherScreen()],
      ),
    );
  }
}
