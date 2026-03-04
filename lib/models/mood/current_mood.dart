class CurrentMood {
  final int memberId;
  final String memberAvatarUrl;
  final String currentMood;
  final int currentMoodId;
  final DateTime moodUpdatedAt;

  final int? partnerMemberId;
  final String? partnerAvatarUrl;
  final String? partnerMood;
  final int? partnerMoodId;
  final DateTime? partnerMoodUpdatedAt;

  final String? coupleMood;
  final String? description;

  final bool isCouple;
  final bool hasCoupleMood;

  CurrentMood({
    required this.memberId,
    required this.memberAvatarUrl,
    required this.currentMood,
    required this.currentMoodId,
    required this.moodUpdatedAt,
    this.partnerMemberId,
    this.partnerAvatarUrl,
    this.partnerMood,
    this.partnerMoodId,
    this.partnerMoodUpdatedAt,
    this.coupleMood,
    this.description,
    required this.isCouple,
    required this.hasCoupleMood,
  });

  factory CurrentMood.fromJson(Map<String, dynamic> json) {
    return CurrentMood(
      memberId: json['memberId'] as int,
      memberAvatarUrl: json['memberAvatarUrl'] as String,
      currentMood: json['currentMood'] as String,
      currentMoodId: json['currentMoodId'] as int,
      moodUpdatedAt: DateTime.parse(json['moodUpdatedAt'] as String),
      partnerMemberId: json['partnerMemberId'] as int?,
      partnerAvatarUrl: json['partnerAvatarUrl'] as String?,
      partnerMood: json['partnerMood'] as String?,
      partnerMoodId: json['partnerMoodId'] as int?,
      partnerMoodUpdatedAt: json['partnerMoodUpdatedAt'] != null
          ? DateTime.parse(json['partnerMoodUpdatedAt'] as String)
          : null,
      coupleMood: json['coupleMood'] as String?,
      description: json['description'] as String?,
      isCouple: json['isCouple'] as bool,
      hasCoupleMood: json['hasCoupleMood'] as bool,
    );
  }
}
