class CurrentMood {
  final int memberId;
  final String memberName;
  final String? memberAvatarUrl;
  final String? currentMood;
  final int? currentMoodId;
  final DateTime? moodUpdatedAt;

  final int? partnerMemberId;
  final String? partnerMemberName;
  final String? partnerAvatarUrl;
  final String? partnerMood;
  final int? partnerMoodId;
  final DateTime? partnerMoodUpdatedAt;

  final String? coupleMood;
  final String? description;

  final bool isCouple;
  final bool hasCoupleMood;
  final int? coupleProfileId;

  CurrentMood({
    required this.memberId,
    required this.memberName,
    this.memberAvatarUrl,
    this.currentMood,
    this.currentMoodId,
    this.moodUpdatedAt,
    this.partnerMemberId,
    this.partnerMemberName,
    this.partnerAvatarUrl,
    this.partnerMood,
    this.partnerMoodId,
    this.partnerMoodUpdatedAt,
    this.coupleMood,
    this.description,
    required this.isCouple,
    required this.hasCoupleMood,
    this.coupleProfileId,
  });

  factory CurrentMood.fromJson(Map<String, dynamic> json) {
    return CurrentMood(
      memberId: json['memberId'] as int,
      memberName: json['memberName'] as String,
      memberAvatarUrl: json['memberAvatarUrl'] as String?,
      currentMood: json['currentMood'] as String?,
      currentMoodId: json['currentMoodId'] as int?,
      moodUpdatedAt: json['moodUpdatedAt'] != null
          ? DateTime.parse(json['moodUpdatedAt'] as String)
          : null,
      partnerMemberId: json['partnerMemberId'] as int?,
      partnerMemberName: json['partnerMemberName'] as String?,
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
      coupleProfileId: json['coupleProfileId'] as int?,
    );
  }
}
