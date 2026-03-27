import 'package:couple_mood_mobile/services/wallet/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:couple_mood_mobile/models/session.dart';
import 'package:couple_mood_mobile/models/wallet/exchange_rate.dart';
import 'package:couple_mood_mobile/models/wallet/wallet_transaction.dart';
import 'package:couple_mood_mobile/providers/user/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/payment/payment_service.dart';
import '../../utils/session_storage.dart';

class WalletProvider extends ChangeNotifier {
  int moneyBalance = 0;
  int pointsBalance = 0;
  ExchangeRate? exchangeRate;
  List<WalletTransaction> transactions = [];

  bool isLoading = false;
  bool isLoadingConvert = false;
  String? error;

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
  Future<bool> topup(int amount) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      if (amount < 1000) {
        error = "Tối thiểu 1000 VND";
        return false;
      }

      final response = await PaymentService.momoTopup(amount: amount);

      if (response.code != 200 || response.data == null) {
        error = 'Topup failed: ${response.message ?? response.code}';
        return false;
      }

      final data = response.data!;

      final String deepLink = data.deepLink;
      final String deeplinkMiniApp = data.deeplinkMiniApp;
      final String payUrl = data.payUrl;

      bool launched = false;

      if (deepLink.isNotEmpty) {
        launched = await launchUrl(
          Uri.parse(deepLink),
          mode: LaunchMode.externalApplication,
        );
        if (!launched && deeplinkMiniApp.isNotEmpty) {
          launched = await launchUrl(
            Uri.parse(deeplinkMiniApp),
            mode: LaunchMode.externalApplication,
          );
        }
        if (!launched && payUrl.isNotEmpty) {
          launched = await launchUrl(
            Uri.parse(payUrl),
            mode: LaunchMode.externalApplication,
          );
        }
      } else if (deeplinkMiniApp.isNotEmpty) {
        launched = await launchUrl(
          Uri.parse(deeplinkMiniApp),
          mode: LaunchMode.externalApplication,
        );
        if (!launched && payUrl.isNotEmpty) {
          launched = await launchUrl(
            Uri.parse(payUrl),
            mode: LaunchMode.externalApplication,
          );
        }
      } else if (payUrl.isNotEmpty) {
        launched = await launchUrl(
          Uri.parse(payUrl),
          mode: LaunchMode.externalApplication,
        );
      }

      if (launched) {
        return true;
      } else {
        error = "Không thể mở MoMo";
        return false;
      }
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
}
