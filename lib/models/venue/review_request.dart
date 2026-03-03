class ReviewRequest {
  final int venueLocationId;
  final int checkInId;
  final String content;
  final int rating;
  final bool isAnonymous;
  final List<String>? imageUrls;

  ReviewRequest({
    required this.venueLocationId,
    required this.checkInId,
    required this.content,
    required this.rating,
    required this.isAnonymous,
    this.imageUrls,
  });

  Map<String, dynamic> toJson() {
    return {
      "venueLocationId": venueLocationId,
      "checkInId": checkInId,
      "content": content,
      "rating": rating,
      "isAnonymous": isAnonymous,
      "images": imageUrls,
    };
  }
}
