class UserState {
  final bool hasReviewedBefore;
  final int? activeCheckInId;
  final bool canReview;

  UserState({
    required this.hasReviewedBefore,
    required this.activeCheckInId,
    required this.canReview,
  });

  factory UserState.fromJson(Map<String, dynamic> json) {
    return UserState(
      hasReviewedBefore: json['hasReviewedBefore'] ?? false,
      activeCheckInId: (json['activeCheckInId'] as num?)?.toInt(),
      canReview: json['canReview'] ?? false,
    );
  }
}
