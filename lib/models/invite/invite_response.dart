class InviteResponse {
  final String coupleName;
  final String startDate;

  InviteResponse({
    required this.coupleName,
    required this.startDate,
  });

  factory InviteResponse.fromJson(Map<String, dynamic> json) {
    return InviteResponse(
      coupleName: json['coupleName']?.toString() ?? '',
      startDate: json['startDate']?.toString() ?? '',
    );
  }
}