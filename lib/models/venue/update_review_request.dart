class UpdateReviewRequest {
  final int venueLocationId;
  final int rating;
  final String content;
  final bool isAnonymous;
  final List<String>? deletedImageUrls;
  final List<String>? newImages;

  UpdateReviewRequest({
    required this.venueLocationId,
    required this.rating,
    required this.content,
    required this.isAnonymous,
    this.deletedImageUrls,
    this.newImages,
  });

  Map<String, dynamic> toJson() {
    return {
      "venueLocationId": venueLocationId,
      "rating": rating,
      "content": content,
      "isAnonymous": isAnonymous,
      "deletedImageUrls": deletedImageUrls,
      "newImages": newImages,
    };
  }
}
