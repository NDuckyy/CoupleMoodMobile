import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/payment/payment_service.dart';
import '../../utils/session_storage.dart';

class WalletProvider extends ChangeNotifier {
  int balance = 0;
  bool isLoading = false;
  String? error;

  Future<void> loadBalance() async {
    final session = await SessionStorage.load();
    balance = session?.balance ?? 0;
    notifyListeners();
  }

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
}
