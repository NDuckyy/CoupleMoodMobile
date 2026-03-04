import 'package:couple_mood_mobile/models/checkin/checkin_payload.dart';

class CheckInSession {
  static CheckInPayload? lastCheckIn;
  static int? checkInId;

  Map<String, dynamic> toJson() => {
    "lastCheckIn": lastCheckIn?.toJson(),
    "checkInId": checkInId,
  };
}
