import 'package:couple_mood_mobile/models/subscription/member_subscription.dart';
import 'package:couple_mood_mobile/models/subscription/subscription_package.dart';
import 'package:couple_mood_mobile/services/payment/payment_service.dart';
import 'package:couple_mood_mobile/services/subscription/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

enum PaymentMethod { momo, zalopay }

class SubscriptionProvider extends ChangeNotifier {
  List<SubscriptionPackage> packages = [];
  MemberSubscription? currentSubscription;

  bool loading = false;
  bool isPaying = false;
  int? selectedPackageId;

  String? error;

  static const MethodChannel platform = MethodChannel('zalopay_channel');

  /// LOAD PACKAGES + CURRENT SUB
  Future<void> fetchAll() async {
    try {
      loading = true;
      notifyListeners();

      final pkgRes = await SubscriptionPackageService.getMemberPackages();
      final subRes = await SubscriptionPackageService.getCurrentSubscription();

      packages = pkgRes.data ?? [];
      currentSubscription = subRes.data;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// PUBLIC METHOD
  Future<bool> buyPackage(int packageId, PaymentMethod method) async {
    if (method == PaymentMethod.momo) {
      return _buyMomo(packageId);
    } else {
      return _buyZaloPay(packageId);
    }
  }

  /// MOMO PAYMENT
  Future<bool> _buyMomo(int packageId) async {
    try {
      _startPaying(packageId);

      final response = await PaymentService.momoPay(packageId: packageId);

      if (response.code != 200 || response.data == null) {
        error = 'Payment init failed: ${response.message ?? response.code}';
        return false;
      }

      final data = response.data!;

      final deepLink = data.deepLink;
      final miniAppLink = data.deeplinkMiniApp;
      final payUrl = data.payUrl;

      bool launched = false;

      if (deepLink.isNotEmpty) {
        launched = await _launch(deepLink);

        if (!launched && miniAppLink.isNotEmpty) {
          launched = await _launch(miniAppLink);
        }

        if (!launched && payUrl.isNotEmpty) {
          launched = await _launch(payUrl);
        }
      } else if (miniAppLink.isNotEmpty) {
        launched = await _launch(miniAppLink);

        if (!launched && payUrl.isNotEmpty) {
          launched = await _launch(payUrl);
        }
      } else if (payUrl.isNotEmpty) {
        launched = await _launch(payUrl);
      }

      if (!launched) {
        error = 'Không thể mở MoMo';
      }

      return launched;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      _finishPaying();
    }
  }

  /// ZALOPAY PAYMENT
  Future<bool> _buyZaloPay(int packageId) async {
    try {
      _startPaying(packageId);

      final response = await PaymentService.zaloPay(packageId: packageId);

      if (response.code != 200 || response.data == null) {
        error = 'Payment init failed: ${response.message ?? response.code}';
        return false;
      }

      final data = response.data!;

      final token = data.zpTransToken;
      final orderUrl = data.orderUrl;

      bool launched = false;

      /// OPEN ZALOPAY SDK
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

      /// FALLBACK WEB
      if (!launched && orderUrl.isNotEmpty) {
        launched = await _launch(orderUrl);
      }

      if (!launched) {
        error = 'Không thể mở ZaloPay';
      }

      return launched;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      _finishPaying();
    }
  }

  /// LAUNCH URL HELPER
  Future<bool> _launch(String url) async {
    final uri = Uri.parse(url);
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  /// STATE HELPERS
  void _startPaying(int packageId) {
    isPaying = true;
    selectedPackageId = packageId;
    notifyListeners();
  }

  void _finishPaying() {
    isPaying = false;
    selectedPackageId = null;
    notifyListeners();
  }

  bool isCurrentPackage(int packageId) {
    return currentSubscription?.packageId == packageId &&
        currentSubscription?.status == "ACTIVE";
  }
}
