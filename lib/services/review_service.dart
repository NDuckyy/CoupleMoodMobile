import 'package:couple_mood_mobile/services/api_client.dart';
import 'package:couple_mood_mobile/models/checkin_payload.dart';
import 'package:couple_mood_mobile/services/checkin_session.dart';

class ReviewService {

  static Future<void> triggerCheckIn(CheckInPayload payload) async {
    final res = await ApiClient.request(
      "/Review/check-in-trigger",
      method: HttpMethod.post,
      data: payload.toJson(),
    );

    if (res != null && res["checkInId"] != null) {
      CheckInSession.checkInId = res["checkInId"];
    }
  }

  static Future<void> validateCheckIn() async {

    if (CheckInSession.lastCheckIn == null ||
        CheckInSession.checkInId == null) return;

    await ApiClient.request(
      "/Review/validate-condition",
      method: HttpMethod.post,
      query: {
        "checkInId": CheckInSession.checkInId,
      },
      data: CheckInSession.lastCheckIn!.toJson(),
    );
  }
}