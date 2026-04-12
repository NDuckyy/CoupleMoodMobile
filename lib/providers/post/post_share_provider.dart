import 'package:flutter/material.dart';
import '../../models/post/post_detail_model.dart';
import '../../services/post/post_service.dart';

class PostShareProvider extends ChangeNotifier {
  PostDetailModel? post;
  bool loading = false;
  String? error;

  Future<void> loadByShareCode(String code) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final res = await PostService.getPostByShareCode(code);

      if (res.code == 200 && res.data != null) {
        post = res.data;
      } else {
        error = "Không tìm thấy bài viết";
      }
    } catch (e) {
      error = "Lỗi tải dữ liệu";
    }

    loading = false;
    notifyListeners();
  }
}
