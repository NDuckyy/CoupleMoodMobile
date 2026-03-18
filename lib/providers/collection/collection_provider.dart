import 'package:flutter/foundation.dart';
import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/collection/collection_item.dart';
import 'package:couple_mood_mobile/models/paginated_response.dart';
import 'package:couple_mood_mobile/services/collection/collection_service.dart';

class CollectionProvider extends ChangeNotifier {
  ApiResponse<PaginatedResponse<CollectionItem>>? collectionsResponse;
  bool isLoading = false;
  String? error;
  int? defaultCollectionId;
  CollectionItem? currentCollection;

  Future<void> getMyCollections({int page = 1, int pageSize = 10}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final collectionsRes = await CollectionService.getMyCollections(
        page: page,
        pageSize: pageSize,
      );

      final currentRes = await CollectionService.getCurrentCollection();

      collectionsResponse = collectionsRes;
      defaultCollectionId = currentRes.data?.id;

      if (defaultCollectionId != null &&
          collectionsResponse?.data?.items != null) {
        final items = collectionsResponse!.data!.items;

        final index = items.indexWhere((e) => e.id == defaultCollectionId);

        if (index > 0) {
          final defaultItem = items.removeAt(index);
          items.insert(0, defaultItem);
        }
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<CollectionItem> get collections =>
      collectionsResponse?.data?.items ?? [];

  Future<CollectionItem> createCollection({
    required String name,
    required String description,
    required String imgUrl,
    required String status,
  }) async {
    try {
      final response = await CollectionService.createCollection(
        name: name,
        description: description,
        imgUrl: imgUrl,
        status: status,
      );

      final newCollection = response.data!;

      // add đầu listt nếu có list
      if (collectionsResponse?.data?.items != null) {
        collectionsResponse!.data!.items.insert(0, newCollection);
        notifyListeners();
      }

      return newCollection;
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<CollectionItem> updateCollection({
    required int id,
    required String name,
    required String description,
    required String imgUrl,
    required String status,
  }) async {
    try {
      final response = await CollectionService.updateCollection(
        id: id,
        name: name,
        description: description,
        imgUrl: imgUrl,
        status: status,
      );

      final updatedCollection = response.data!;

      // update local list nếu có
      final index = collections.indexWhere((e) => e.id == id);

      if (index != -1) {
        collectionsResponse!.data!.items[index] = updatedCollection;
        notifyListeners();
      }

      return updatedCollection;
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> deleteCollection(int id) async {
    try {
      await CollectionService.deleteCollection(id);

      // Xoá khỏi local list nếu có
      if (collectionsResponse?.data?.items != null) {
        collectionsResponse!.data!.items.removeWhere(
          (element) => element.id == id,
        );
        notifyListeners();
      }
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> getCurrentCollection() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await CollectionService.getCurrentCollection();
      currentCollection = response.data;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// REMOVE SINGLE
  Future<void> removeVenue({
    required int collectionId,
    required int venueId,
  }) async {
    await removeVenues(collectionId: collectionId, venueIds: [venueId]);
  }

  /// REMOVE BULK
  Future<void> removeVenues({
    required int collectionId,
    required List<int> venueIds,
  }) async {
    try {
      await CollectionService.removeVenuesFromCollection(
        collectionId: collectionId,
        venueIds: venueIds,
      );
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> addVenuesToCollection({
    required int collectionId,
    required List<int> venueIds,
  }) async {
    await CollectionService.addVenuesToCollection(
      collectionId: collectionId,
      venueIds: venueIds,
    );
  }
}
