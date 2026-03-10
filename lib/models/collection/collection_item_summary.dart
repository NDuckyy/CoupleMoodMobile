class CollectionItemSummary {
  final int id;
  final String collectionName;
  final String description;
  final String? img;
  final String status;

  CollectionItemSummary({
    required this.id,
    required this.collectionName,
    required this.description,
    required this.status,
    this.img,
  });

  factory CollectionItemSummary.fromJson(Map<String, dynamic> json) {
    return CollectionItemSummary(
      id: json['id'],
      collectionName: json['collectionName'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      img: json['img'],
    );
  }
}
