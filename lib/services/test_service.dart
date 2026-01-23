import 'package:couple_mood_mobile/models/test.dart';
import 'package:couple_mood_mobile/services/api_client.dart';

class TestService {
  Future<List<Test>> getListTest() async {
    final res = await ApiClient.request("/TestType", method: HttpMethod.get);
    try {
      final root = (res as Map).cast<String, dynamic>();
      final List<dynamic> data = (root['data'] as List).cast<dynamic>();
      return Test.fromJsonList(data);
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách bài test: $e');
    }
  }
}
