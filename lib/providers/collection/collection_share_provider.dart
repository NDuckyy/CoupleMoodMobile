import 'package:couple_mood_mobile/models/collection/collection_item.dart';
import 'package:couple_mood_mobile/services/collection/collection_service.dart';
import 'package:flutter/material.dart';

class CollectionShareProvider extends ChangeNotifier {
  CollectionItem? collection;
  bool loading = false;
  String? error;

  Future<void> loadByShareCode(String code) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final res = await CollectionService.getCollectionByShareCode(code);

      if (res.code == 200 && res.data != null) {
        collection = res.data;
      } else {
        error = "Không tìm thấy bộ sưu tập";
      }
    } catch (e) {
      error = "Lỗi tải dữ liệu";
    }

    loading = false;
    notifyListeners();
  }
}
