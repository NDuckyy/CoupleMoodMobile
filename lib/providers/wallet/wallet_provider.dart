import 'package:couple_mood_mobile/services/wallet/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:couple_mood_mobile/models/session.dart';
import 'package:couple_mood_mobile/models/wallet/exchange_rate.dart';
import 'package:couple_mood_mobile/models/wallet/wallet_transaction.dart';
import 'package:couple_mood_mobile/providers/user/user_provider.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/payment/payment_service.dart';
import '../../utils/session_storage.dart';

enum PaymentMethod { momo, zalopay }

class WalletProvider extends ChangeNotifier {
  int moneyBalance = 0;
  int pointsBalance = 0;
  ExchangeRate? exchangeRate;
  List<WalletTransaction> transactions = [];

  bool isLoading = false;
  bool isLoadingConvert = false;
  String? error;

  static const MethodChannel platform = MethodChannel('zalopay_channel');

  // ==================== LOAD + SYNC TỪ SERVER ====================
  Future<void> loadWalletData(BuildContext context) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Sync user từ /auth/me
      final userProvider = context.read<UserProvider>();
      await userProvider.fetchMe();

      final session = await SessionStorage.load();
      moneyBalance = (session?.balance ?? 0).toInt();
      pointsBalance = (session?.points ?? 0).toInt();

      // Exchange rate
      final rateRes = await WalletService.getExchangeRate();
      if (rateRes.code == 200 && rateRes.data != null) {
        exchangeRate = rateRes.data;
      }

      // Transactions - Bắt lỗi double → int
      final transRes = await WalletService.getTransactions(
        page: 1,
        pageSize: 20,
      );
      if (transRes.code == 200 && transRes.data != null) {
        transactions = (transRes.data!.items ?? []).map((tx) {
          return tx;
        }).toList();
      }
    } catch (e, stackTrace) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ==================== TOPUP ====================

  Future<bool> topup(int amount, PaymentMethod method) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      if (amount < 1000) {
        error = "Tối thiểu 1000 VND";
        return false;
      }

      if (method == PaymentMethod.momo) {
        return await _topupMomo(amount);
      } else {
        return await _topupZalo(amount);
      }
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> _topupMomo(int amount) async {
    final response = await PaymentService.momoTopup(amount: amount);

    if (response.code != 200 || response.data == null) {
      error = 'Topup failed: ${response.message ?? response.code}';
      return false;
    }

    final data = response.data!;

    final deepLink = data.deepLink;
    final mini = data.deeplinkMiniApp;
    final payUrl = data.payUrl;

    bool launched = false;

    if (deepLink.isNotEmpty) {
      launched = await _launch(deepLink);
      if (!launched && mini.isNotEmpty) launched = await _launch(mini);
      if (!launched && payUrl.isNotEmpty) launched = await _launch(payUrl);
    } else if (mini.isNotEmpty) {
      launched = await _launch(mini);
      if (!launched && payUrl.isNotEmpty) launched = await _launch(payUrl);
    } else if (payUrl.isNotEmpty) {
      launched = await _launch(payUrl);
    }

    if (!launched) error = "Không thể mở MoMo";

    return launched;
  }

  Future<bool> _topupZalo(int amount) async {
    final response = await PaymentService.zaloTopup(amount: amount);

    if (response.code != 200 || response.data == null) {
      error = 'Topup failed: ${response.message ?? response.code}';
      return false;
    }

    final data = response.data!;

    final token = data.zpTransToken;
    final orderUrl = data.orderUrl;

    bool launched = false;

    /// 1. Native SDK
    if (token.isNotEmpty) {
      try {
        final result = await platform.invokeMethod('payOrder', {
          "zptoken": token,
        });

        debugPrint("ZaloPay result: $result");
        launched = result != null;
      } catch (e) {
        debugPrint("ZaloPay native fail: $e");
      }
    }

    /// 2. fallback web
    if (!launched && orderUrl.isNotEmpty) {
      launched = await _launch(orderUrl);
    }

    if (!launched) error = "Không thể mở ZaloPay";

    return launched;
  }

  // ==================== CONVERT MONEY → POINT ====================
  // ← ĐÃ SỬA: nhận BuildContext để gọi UserProvider an toàn
  Future<bool> convertMoneyToPoint(int amount, BuildContext context) async {
    isLoadingConvert = true;
    error = null;
    notifyListeners();

    try {
      if (amount < 1000 || moneyBalance < amount) {
        error = amount < 1000 ? "Tối thiểu 1000 VND" : "Số dư ví tiền không đủ";
        return false;
      }

      final response = await WalletService.convertMoneyToPoint(amount: amount);

      if (response.code != 200 || response.data == null) {
        error = response.message ?? 'Chuyển đổi thất bại';
        return false;
      }

      final data = response.data!;

      // Update Session ngay (UI mượt)
      final currentSession = await SessionStorage.load();
      if (currentSession != null) {
        await SessionStorage.save(
          Session(
            accessToken: currentSession.accessToken,
            refreshToken: currentSession.refreshToken,
            userId: currentSession.userId,
            avatarUrl: currentSession.avatarUrl,
            fullName: currentSession.fullName,
            gender: currentSession.gender,
            dateOfBirth: currentSession.dateOfBirth,
            inviteCode: currentSession.inviteCode,
            balance: data.balanceAfter,
            points: data.pointsAfter,
          ),
        );
      }

      // Update local state
      moneyBalance = data.balanceAfter.toInt();
      pointsBalance = data.pointsAfter.toInt();

      // Sync 1 lần nữa từ server (đảm bảo multi-device)
      final userProvider = context.read<UserProvider>();
      await userProvider.fetchMe();

      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoadingConvert = false;
      notifyListeners();
    }
  }

  Future<void> refresh(BuildContext context) async =>
      await loadWalletData(context);

  /// LAUNCH URL HELPER
  Future<bool> _launch(String url) async {
    final uri = Uri.parse(url);
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
