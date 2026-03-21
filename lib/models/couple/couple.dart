class Couple {
   final int coupleId;
  final String? coupleName;
  final String startDate;
  final String? aniversaryDate;
  final double? budgetMin;
  final double? budgetMax;
  final int totalPoints;
  final int interactionPoints;
  final String status;
  final String createdAt;
  final String updatedAt;

  final int memberId1;
  final String member1Name;
  final String? member1AvatarUrl;
  final String member1Gender;
  final String member1DateOfBirth;

  final int memberId2;
  final String member2Name;
  final String? member2AvatarUrl;
  final String member2Gender;
  final String member2DateOfBirth;

  final int? couplePersonalityTypeId;
  final String? couplePersonalityTypeName;
  final String? couplePersonalityTypeDescription;

  final int? coupleMoodTypeId;
  final String? coupleMoodTypeName;
  final String? coupleMoodTypeDescription;

  Couple({
    required this.coupleId,
    this.coupleName,
    required this.startDate,
    this.aniversaryDate,
    this.budgetMin,
    this.budgetMax,
    required this.totalPoints,
    required this.interactionPoints,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.memberId1,
    required this.member1Name,
    this.member1AvatarUrl,
    required this.member1Gender,
    required this.member1DateOfBirth,
    required this.memberId2,
    required this.member2Name,
    this.member2AvatarUrl,
    required this.member2Gender,
    required this.member2DateOfBirth,
    this.couplePersonalityTypeId,
    this.couplePersonalityTypeName,
    this.couplePersonalityTypeDescription,
    this.coupleMoodTypeId,
    this.coupleMoodTypeName,
    this.coupleMoodTypeDescription,
  });

  factory Couple.fromJson(Map<String, dynamic> json) {
    return Couple(
      coupleId: json['coupleId'] as int,
      coupleName: json['coupleName'] as String?,
      startDate: json['startDate'] as String,
      aniversaryDate: json['aniversaryDate'] as String?,
      budgetMin: (json['budgetMin'] as num?)?.toDouble(),
      budgetMax: (json['budgetMax'] as num?)?.toDouble(),
      totalPoints: json['totalPoints'] as int,
      interactionPoints: json['interactionPoints'] as int,
      status: json['status'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      memberId1: json['memberId1'] as int,
      member1Name: json['member1Name'] as String,
      member1AvatarUrl: json['member1AvatarUrl'] as String?,
      member1Gender: json['member1Gender'] as String,
      member1DateOfBirth: json['member1DateOfBirth'] as String,
      memberId2: json['memberId2'] as int,
      member2Name: json['member2Name'] as String,
      member2AvatarUrl: json['member2AvatarUrl'] as String?,
      member2Gender: json['member2Gender'] as String,
      member2DateOfBirth: json['member2DateOfBirth'] as String,
      couplePersonalityTypeId:
          json['couplePersonalityTypeId'] as int? ?? 0, // Default to 0 if null
      couplePersonalityTypeName:
          json['couplePersonalityTypeName'] as String? ?? '',
      couplePersonalityTypeDescription:
          json['couplePersonalityTypeDescription'] as String? ?? '',
      coupleMoodTypeId: json['coupleMoodTypeId'] as int? ?? 0, // Default to 0 if null
      coupleMoodTypeName: json['coupleMoodTypeName'] as String? ?? '',
      coupleMoodTypeDescription:
          json['coupleMoodTypeDescription'] as String? ?? '',
    );
  }

}