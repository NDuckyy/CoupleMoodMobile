import 'package:couple_mood_mobile/models/subscription/subscription_package.dart';
import 'package:couple_mood_mobile/services/api_client.dart';
import 'package:couple_mood_mobile/services/payment/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionProvider extends ChangeNotifier {
  List<SubscriptionPackage> packages = [];
  bool loading = false;
  bool isPaying = false;
  int? selectedPackageId;
  String? error;

  Future<void> fetchPackages() async {
    try {
      loading = true;
      notifyListeners();

      final res = await ApiClient.request(
        '/MemberSubscription/packages?pageNumber=1&pageSize=10',
        method: HttpMethod.get,
      );

      final items = res['data']['items'] as List;

      packages = items.map((e) => SubscriptionPackage.fromJson(e)).toList();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> buyPackage(int packageId) async {
    try {
      isPaying = true;
      selectedPackageId = packageId;
      notifyListeners();

      final response = await PaymentService.momoPay(packageId: packageId);

      if (response.code != 200 || response.data == null) {
        error = 'Payment init failed: ${response.message ?? response.code}';
        return false;
      }

      final data = response.data!;

      // Lấy trực tiếp từ model (không cần fallback key chữ thường nữa)
      final String deepLink = data.deepLink; // non-nullable
      final String deeplinkMiniApp = data.deeplinkMiniApp; // non-nullable
      final String payUrl = data.payUrl; // non-nullable

      bool launched = false;

      // Ưu tiên deepLink (scheme momo:// chính)
      if (deepLink.isNotEmpty) {
        final uri = Uri.parse(deepLink);
        launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

        // Nếu deepLink fail, thử deeplinkMiniApp
        if (!launched && deeplinkMiniApp.isNotEmpty) {
          launched = await launchUrl(
            Uri.parse(deeplinkMiniApp),
            mode: LaunchMode.externalApplication,
          );
        }

        // Nếu cả hai đều fail, fallback sang payUrl (web)
        if (!launched && payUrl.isNotEmpty) {
          launched = await launchUrl(
            Uri.parse(payUrl),
            mode: LaunchMode.externalApplication,
          );
        }
      }
      // Nếu deepLink rỗng, thử deeplinkMiniApp trước
      else if (deeplinkMiniApp.isNotEmpty) {
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
      }
      // Cuối cùng chỉ còn payUrl
      else if (payUrl.isNotEmpty) {
        launched = await launchUrl(
          Uri.parse(payUrl),
          mode: LaunchMode.externalApplication,
        );
      }

      if (launched) {
        return true;
      } else {
        error = 'Không thể mở MoMo hoặc link thanh toán';
        return false;
      }
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isPaying = false;
      selectedPackageId = null;
      notifyListeners();
    }
  }
}
