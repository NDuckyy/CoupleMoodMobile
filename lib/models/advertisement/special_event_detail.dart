class SpecialEventDetail {
  final int id;
  final String eventName; 
  final String description;
  final String startDate;
  final String endDate;
  final String bannerUrl;

  SpecialEventDetail({
    required this.id,
    required this.eventName,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.bannerUrl,
  });

  factory SpecialEventDetail.fromJson(Map<String, dynamic> json) {
    return SpecialEventDetail(
      id: json['id'],
      eventName: json['eventName'],
      description: json['description'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      bannerUrl: json['bannerUrl'],
    );
  }
  
}