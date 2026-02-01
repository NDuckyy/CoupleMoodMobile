import 'couple_mood_type_model.dart';
import 'couple_personality_type_model.dart';

class LocationTag {
  final int id;
  final String tagName;
  final CoupleMoodType coupleMoodType;
  final CouplePersonalityType couplePersonalityType;

  LocationTag({
    required this.id,
    required this.tagName,
    required this.coupleMoodType,
    required this.couplePersonalityType,
  });

  factory LocationTag.fromJson(Map<String, dynamic> json) {
    return LocationTag(
      id: json['id'],
      tagName: json['tagName'],
      coupleMoodType: CoupleMoodType.fromJson(json['coupleMoodType']),
      couplePersonalityType: CouplePersonalityType.fromJson(
        json['couplePersonalityType'],
      ),
    );
  }
}
