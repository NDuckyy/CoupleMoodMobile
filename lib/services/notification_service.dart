import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/notification/notification.dart';
import 'package:couple_mood_mobile/services/api_client.dart';
import 'package:couple_mood_mobile/utils/session_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
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
          "platform": Platform.isAndroid ? "android" : "ios",
        },
      );

      print("TOKEN SENT TO BE ✅");
    } catch (e) {
      print("SEND TOKEN FAILED ❌: $e");
    }
  }

  Future<void> setupInteractedMessage() async {
    // 🔥 BACKGROUND → click notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await LocalNotificationService.handleNotificationNavigation(message.data);
    });

    // 🔥 KILLED → mở app từ notification
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      Future.delayed(const Duration(milliseconds: 8000), () async {
        await LocalNotificationService.handleNotificationNavigation(
          Map<String, dynamic>.from(initialMessage.data),
        );
      });
    }
  }

  static void listenNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🔥 FOREGROUND MESSAGE: ${message.data}");

      final title = message.notification?.title ?? "No title";
      final body = message.notification?.body ?? "No body";

      if (message.notification != null) {
        if (message.data['type'] == "CHAT") {
          final conversationId = int.parse(
            message.data['conversationId'] ?? "0",
          );

          LocalNotificationService.show(
            title,
            body,
            payload: "CHAT|$conversationId",
          );
        } else {
          final checkinId = message.data['refId'] ?? "";
          final venueLocationId = message.data['venueLocationId'] ?? "";

          LocalNotificationService.show(
            title,
            body,
            payload: "$venueLocationId|$checkinId",
          );
        }
      }
    });
  }

  static Future<void> requestNotificationPermission() async {
    await FirebaseMessaging.instance.requestPermission();
  }

  static Future<ApiResponse<NotificationPagination>> getNotification(
    int pageNumber,
    int pageSize,
    String type,
  ) async {
    try {
      final response = await ApiClient.request(
        '/Notification',
        method: HttpMethod.get,
        query: {
          'pageNumber': pageNumber.toString(),
          'pageSize': pageSize.toString(),
          'type': type,
        },
      );
      return ApiResponse.fromJson(
        response,
        (json) => NotificationPagination.fromJson(json),
      );
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi lấy thông báo: $e');
    }
  }
}
