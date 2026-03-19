import 'package:couple_mood_mobile/providers/voucher/my_voucher_provider.dart';
import 'package:couple_mood_mobile/providers/voucher/voucher_list_provider.dart';
import 'package:couple_mood_mobile/screens/voucher/my_voucher_screen.dart';
import 'package:couple_mood_mobile/screens/voucher/voucher_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VoucherHubScreen extends StatefulWidget {
  const VoucherHubScreen({super.key});

  @override
  State<VoucherHubScreen> createState() => _VoucherHubScreenState();
}

class _VoucherHubScreenState extends State<VoucherHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VoucherProvider()),
        ChangeNotifierProvider(
          create: (_) => MyVoucherProvider()..fetchMyVouchers(refresh: true),
        ),
      ],
      child: Scaffold(
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
      ),
    );
  }
}
