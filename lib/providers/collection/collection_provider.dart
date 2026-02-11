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
}
