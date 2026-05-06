class StreakModel {
  final int? currentStreak;
  final int? longestStreak;
  final bool hasCheckedInToday;
  final List<DayStreak>? days;

  StreakModel({
    this.currentStreak,
    required this.hasCheckedInToday,
    this.longestStreak,
    this.days,
  });

  factory StreakModel.fromJson(Map<String, dynamic> json) {
    return StreakModel(
      currentStreak: json['currentStreak'],
      longestStreak: json['longestStreak'],
      hasCheckedInToday: json['hasCheckedInToday'] ?? false,
      days: json['days'] != null
          ? (json['days'] as List).map((e) => DayStreak.fromJson(e)).toList()
          : null,
    );
  }
}

class DayStreak {
  final String? date;
  final bool hasCheckedIn;

  DayStreak({this.date, required this.hasCheckedIn});

  factory DayStreak.fromJson(Map<String, dynamic> json) {
    return DayStreak(
      date: json['date'],
      hasCheckedIn: json['hasCheckedIn'] ?? false,
    );
  }
}
