import 'collection_venue.dart';

class CollectionItem {
  final int id;
  final int memberId;
  final String collectionName;
  final String description;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CollectionVenue> venues;

  CollectionItem({
    required this.id,
    required this.memberId,
    required this.collectionName,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.venues,
  });

  factory CollectionItem.fromJson(Map<String, dynamic> json) {
    return CollectionItem(
      id: json['id'],
      memberId: json['memberId'],
      collectionName: json['collectionName'],
      description: json['description'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      venues: (json['venues'] as List<dynamic>)
          .map((e) => CollectionVenue.fromJson(e))
          .toList(),
    );
  }
}
