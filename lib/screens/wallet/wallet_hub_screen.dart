import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:couple_mood_mobile/providers/wallet/wallet_provider.dart';
import 'package:couple_mood_mobile/widgets/wallet/money_wallet_tab.dart';
import 'package:couple_mood_mobile/widgets/wallet/points_wallet_tab.dart';
import 'package:couple_mood_mobile/widgets/wallet/transactions_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletHubScreen extends StatefulWidget {
  final int initialTab;

  const WalletHubScreen({super.key, this.initialTab = 0});

  @override
  State<WalletHubScreen> createState() => _WalletHubScreenState();
}

class _WalletHubScreenState extends State<WalletHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _gender = 'MALE';

  ColorScheme _getThemeByGender() {
    final isMale = _gender.toUpperCase() == 'MALE';
    if (isMale) {
      return const ColorScheme.light(
        primary: Color(0xFF1E40AF),
        secondary: Color(0xFF3B82F6),
        surface: Color(0xFF1E3A8A),
      );
    } else {
      return const ColorScheme.light(
        primary: Color(0xFF9F1C9F),
        secondary: Color(0xFFEC4899),
        surface: Color(0xFF7E22CE),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab,
    );

    // Load dữ liệu lần đầu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletProvider>().loadWalletData(context);
    });

    // === THÊM: Refresh khi chuyển tab ===
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return; // tránh gọi 2 lần

    final walletProvider = context.read<WalletProvider>();

    // Refresh mạnh khi chuyển sang tab Lịch sử (vì cần dữ liệu mới nhất)
    if (_tabController.index == 2) {
      walletProvider.refresh(context);
    }
    // Refresh nhẹ cho các tab khác (chỉ cập nhật số dư + tỉ lệ)
    else {
      walletProvider.loadWalletData(
        context,
      ); // hoặc tạo method refreshLight() nếu muốn tối ưu
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = context.read<AuthProvider>();
    final newGender = auth.session?.gender ?? 'MALE';
    if (newGender != _gender) {
      setState(() => _gender = newGender);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(
      _handleTabChange,
    ); // Quan trọng: tránh memory leak
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = _getThemeByGender();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: const Text(
          "Ví của tôi",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: colorScheme.primary,
          tabs: const [
            Tab(text: "Ví Tiền"),
            Tab(text: "Ví Điểm"),
            Tab(text: "Lịch sử"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MoneyWalletTab(colorScheme: colorScheme),
          PointsWalletTab(colorScheme: colorScheme),
          const TransactionsTab(),
        ],
      ),
    );
  }
}
