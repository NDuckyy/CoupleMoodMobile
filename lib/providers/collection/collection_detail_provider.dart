import 'package:flutter/foundation.dart';
import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/collection/collection_item.dart';
import 'package:couple_mood_mobile/services/collection/collection_service.dart';

class CollectionDetailProvider extends ChangeNotifier {
  ApiResponse<CollectionItem>? response;
  bool isLoading = false;
  String? error;

  Future<void> getCollectionDetail(int id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      response = await CollectionService.getCollectionDetail(id);
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  CollectionItem? get collection => response?.data;
}
