class CheckinStatus {
  final bool hasCheckedInToday;
  final String? checkedInAt;

  CheckinStatus({required this.hasCheckedInToday, this.checkedInAt});

  factory CheckinStatus.fromJson(Map<String, dynamic> json) {
    return CheckinStatus(
      hasCheckedInToday: json['hasCheckedInToday'],
      checkedInAt: json['checkedInAt'],
    );
  }
}
