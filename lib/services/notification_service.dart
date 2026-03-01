import 'package:couple_mood_mobile/services/api_client.dart';
import 'package:couple_mood_mobile/utils/session_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'local_notification_service.dart';
class NotificationService {
  Future<void> showTestNotification() async {
    await LocalNotificationService.show(
      "Test Notification",
      "Push is working 🚀",
    );
  }

  static Future<void> init() async {

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {

      final session = await SessionStorage.load();

      if (session == null || session.accessToken.isEmpty) {
        print("SKIP TOKEN REFRESH - USER NOT LOGIN");
        return;
      }

      print("REFRESH TOKEN AFTER LOGIN");
      await sendTokenToServer(newToken);
    });

  }

  static Future<void> sendTokenToServerAfterLogin() async {
    final session = await SessionStorage.load();

    if (session == null || session.accessToken.isEmpty) return;

    String? token = await FirebaseMessaging.instance.getToken();

    int retry = 0;

    while (token == null && retry < 5) {
      await Future.delayed(const Duration(seconds: 2));
      token = await FirebaseMessaging.instance.getToken();
      retry++;
    }

    if (token != null) {
      print("TOKEN AFTER LOGIN: $token");
      await sendTokenToServer(token);
    } else {
      print("❌ TOKEN STILL NULL AFTER RETRY");
    }
  }

  static Future<void> sendTokenToServer(String token) async {

    final session = await SessionStorage.load();
    print("SESSION: $session");
    if (session == null || session.accessToken.isEmpty) {
      print("❌ NOT LOGIN -> SKIP SEND TOKEN");
      return;
    }
    try {
      await ApiClient.request(
        "/DeviceToken",
        method: HttpMethod.post,
        data: {
          "token": token,
          "platform": Platform.isAndroid ? "android" : "ios"
        },
      );

      print("TOKEN SENT TO BE ✅");
    } catch (e) {
      print("SEND TOKEN FAILED ❌: $e");
    }
  }

  Future<void> setupInteractedMessage() async {
    // App đang mở
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Foreground message received');
      print(message.notification?.title);
      print(message.notification?.body);
    });

    // App mở từ notification (background -> open)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🔔 User clicked notification');
    });

    // App bị kill và mở từ notification
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print('🚀 App opened from terminated state');
    }
  }
  static void listenNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "No title";
      final body = message.notification?.body ?? "No body";

      LocalNotificationService.show(title, body);
    });
  }

  static Future<void> requestNotificationPermission() async {
    await FirebaseMessaging.instance.requestPermission();
  }

}
