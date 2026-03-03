import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("🔔 Notification clicked");

        if (response.payload == "review") {
          print("➡️ Go to review page");
          // điều hướng sẽ làm ở step 3
        }
      },
    );
  }

  static Future<void> show(String title, String body) async {
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
      payload: "review",
    );
  }
}