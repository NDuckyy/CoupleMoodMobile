import 'package:couple_mood_mobile/routes/app_route.dart';
import 'package:couple_mood_mobile/services/chat/messaging_api_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          final parts = response.payload!.split("|");

          if (parts[0] == "CHAT") {
            await handleNotificationNavigation({
              "type": "CHAT",
              "conversationId": parts[1],
            });
          } else if (parts[0] == "PAIRING") {
            await handleNotificationNavigation({"type": "PAIRING"});
          } else if (parts[0] == "DATE_PLAN") {
            await handleNotificationNavigation({"type": "DATE_PLAN"});
          } else if (parts[0] == "LOCATION") {
            await handleNotificationNavigation({
              "type": "LOCATION",
              "venueLocationId": parts[0],
              "refId": parts[1],
            });
          }
        }
      },
    );
  }

  static Future<void> handleNotificationNavigation(
    Map<String, dynamic> data,
  ) async {
    if (data['type'] == "CHAT") {
      final conversationId = int.parse(data['conversationId'] ?? "0");

      final conversation = await MessagingApiService.getConversationById(
        conversationId,
      );

      navigateToChatScreen(conversation: conversation);
    } else if (data['type'] == "PAIRING") {
      navigateToPairingScreen();
    } else if (data['type'] == "DATE_PLAN") {
      navigateToDatePlanScreen();
    } else if (data['type'] == "LOCATION") {
      final venueId = int.parse(data['venueLocationId'] ?? "0");
      final checkInId = int.parse(data['refId'] ?? "0");

      navigateToReviewVenue(venueId: venueId, checkInId: checkInId);
    }
  }

  static Future<void> show(String title, String body, {String? payload}) async {
    const android = AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: android);

    await _plugin.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }
}
