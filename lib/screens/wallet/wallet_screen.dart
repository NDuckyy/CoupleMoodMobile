import 'package:couple_mood_mobile/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet/wallet_provider.dart';
import '../../utils/currency_utils.dart';
import '../../widgets/snack_bar.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final TextEditingController _amountCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isBalanceVisible = false;

  String _gender = 'MALE'; // Lưu gender ở đây

  // Lấy màu theo gender (đã sửa)
  ColorScheme _getThemeByGender() {
    final isMale = _gender.toUpperCase() == 'MALE';

    if (isMale) {
      return const ColorScheme.light(
        primary: Color(0xFF1E40AF), // Xanh đậm nam
        secondary: Color(0xFF3B82F6), // Xanh sáng
        surface: Color(0xFF1E3A8A),
      );
    } else {
      return const ColorScheme.light(
        primary: Color(0xFF9F1C9F), // Hồng tím nữ
        secondary: Color(0xFFEC4899),
        surface: Color(0xFF7E22CE),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Đọc gender ngay khi khởi tạo
    final auth = context.read<AuthProvider>();
    _gender = auth.session?.gender ?? 'MALE';

    Future.microtask(() => context.read<WalletProvider>().loadBalance());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cập nhật lại gender nếu AuthProvider thay đổi (an toàn hơn)
    final auth = context.read<AuthProvider>();
    final newGender = auth.session?.gender ?? 'MALE';
    if (newGender != _gender) {
      setState(() => _gender = newGender);
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  String formatVND(int amount) {
    return NumberFormat('#,###', 'vi_VN').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final balance = wallet.balance;
    final colorScheme = _getThemeByGender(); // Lấy màu từ state

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
      ),
      body: CustomScrollView(
        slivers: [
          // === Ví 3D Hero ===
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.surface,
                      colorScheme.primary,
                      colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.45),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 25,
                      offset: const Offset(10, 20),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Số dư ví",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                ],
                              ),
                              IconButton(
                                onPressed: () => setState(
                                  () => _isBalanceVisible = !_isBalanceVisible,
                                ),
                                icon: Icon(
                                  _isBalanceVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _isBalanceVisible
                                ? "${formatVND(balance)}đ"
                                : "••••••• đ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _isBalanceVisible ? 36 : 32,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Nạp nhanh
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Nạp nhanh",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [50000, 100000, 200000, 500000].map((amt) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _amountCtrl.text = formatVND(amt),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: colorScheme.primary.withOpacity(0.25),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "${(amt ~/ 1000)}k",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // Form nạp tiền + Nút đẹp
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nhập số tiền nạp",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _amountCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [VNDInputFormatter()],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        prefixText: "đ ",
                        prefixStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                        hintText: "0",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                      ),
                      validator: (value) {
                        final raw = (value ?? '')
                            .replaceAll('.', '')
                            .replaceAll('đ', '')
                            .trim();
                        final amount = int.tryParse(raw);
                        if (raw.isEmpty) return "Vui lòng nhập số tiền";
                        if (amount == null || amount < 1000)
                          return "Tối thiểu 1.000đ";
                        return null;
                      },
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: Material(
                        color: Colors.transparent,
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: wallet.isLoading
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate())
                                    return;

                                  final raw = _amountCtrl.text
                                      .replaceAll('.', '')
                                      .replaceAll('đ', '')
                                      .trim();
                                  final amount = int.parse(raw);

                                  final success = await wallet.topup(amount);
                                  if (success) {
                                    showMsg(
                                      context,
                                      "Đang chuyển hướng đến MoMo...",
                                      true,
                                    );
                                    _amountCtrl.clear();
                                  } else {
                                    showMsg(
                                      context,
                                      wallet.error ?? "Nạp tiền thất bại",
                                      false,
                                    );
                                  }
                                },
                          borderRadius: BorderRadius.circular(20),
                          splashColor: Colors.white.withOpacity(0.25),
                          highlightColor: Colors.white.withOpacity(0.15),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary,
                                  colorScheme.secondary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Center(
                              child: wallet.isLoading
                                  ? const SizedBox(
                                      height: 28,
                                      width: 28,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3.5,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.payment,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          "Nạp tiền qua MoMo",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
