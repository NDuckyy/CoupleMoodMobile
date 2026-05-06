class UpdateReviewRequest {
  final int venueLocationId;
  final int rating;
  final String content;
  final bool isAnonymous;
  final bool isMatched;
  final List<String>? deletedImageUrls;
  final List<String>? newImages;
  final List<int>? coupleMoodTypeIds;

  UpdateReviewRequest({
    required this.venueLocationId,
    required this.rating,
    required this.content,
    required this.isAnonymous,
    required this.isMatched,
    this.deletedImageUrls,
    this.newImages,
    this.coupleMoodTypeIds,
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
      "coupleMoodTypeIds": coupleMoodTypeIds,
    };
  }
}
