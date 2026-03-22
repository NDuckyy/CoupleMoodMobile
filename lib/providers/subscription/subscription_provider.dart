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

      if (response.code == 200 && response.data != null) {
        final deepLink = response.data!.deepLink;
        final url = Uri.parse(deepLink);

        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          final fallbackUrl = Uri.parse(response.data!.payUrl);
          await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
        }

        return true;
      }

      return false;
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
