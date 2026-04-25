class UpdateReviewRequest {
  final int venueLocationId;
  final int rating;
  final String content;
  final bool isAnonymous;
  final bool isMatched;
  final List<String>? deletedImageUrls;
  final List<String>? newImages;

  UpdateReviewRequest({
    required this.venueLocationId,
    required this.rating,
    required this.content,
    required this.isAnonymous,
    required this.isMatched,
    this.deletedImageUrls,
    this.newImages,
  });

  Map<String, dynamic> toJson() {
    return {
      "venueLocationId": venueLocationId,
      "rating": rating,
      "content": content,
      "isAnonymous": isAnonymous,
      "isMatched": isMatched,
      "deletedImageUrls": deletedImageUrls,
      "newImages": newImages,
    };
  }
}
