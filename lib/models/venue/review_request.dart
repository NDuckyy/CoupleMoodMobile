class ReviewRequest {
  final int venueLocationId;
  final int checkInId;
  final String content;
  final int rating;
  final bool isAnonymous;
  final bool isMatched;
  final List<String>? imageUrls;
  final int? coupleMoodTypeId;

  ReviewRequest({
    required this.venueLocationId,
    required this.checkInId,
    required this.content,
    required this.rating,
    required this.isAnonymous,
    required this.isMatched,
    this.imageUrls,
    this.coupleMoodTypeId,
  });

  Map<String, dynamic> toJson() {
    return {
      "venueLocationId": venueLocationId,
      "checkInId": checkInId,
      "content": content,
      "rating": rating,
      "isAnonymous": isAnonymous,
      "isMatched": isMatched,
      "imageUrls": imageUrls,
      "coupleMoodTypeId": coupleMoodTypeId,
    };
  }
}
