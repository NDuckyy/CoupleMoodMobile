import 'package:couple_mood_mobile/routes/app_route.dart';
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
        if (response.payload != null) {
          final parts = response.payload!.split("|");
          final venueId = int.parse(parts[0]);
          final checkInId = int.parse(parts[1]);
          print("Notification clicked with payload: venueId=$venueId, checkInId=$checkInId");
          navigateToReviewVenue(venueId: venueId, checkInId: checkInId);
        }
      },
    );
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
