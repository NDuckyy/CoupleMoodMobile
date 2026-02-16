import 'package:flutter/foundation.dart';
import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/collection/collection_item.dart';
import 'package:couple_mood_mobile/models/paginated_response.dart';
import 'package:couple_mood_mobile/services/collection/collection_service.dart';

class CollectionProvider extends ChangeNotifier {
  ApiResponse<PaginatedResponse<CollectionItem>>? collectionsResponse;
  bool isLoading = false;
  String? error;

  Future<void> getMyCollections({int page = 1, int pageSize = 10}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      collectionsResponse = await CollectionService.getMyCollections(
        page: page,
        pageSize: pageSize,
      );
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
}
