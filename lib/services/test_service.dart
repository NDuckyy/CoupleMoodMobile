import 'package:couple_mood_mobile/models/test/test_detail.dart';
import 'package:couple_mood_mobile/models/test/test_result.dart';
import 'package:couple_mood_mobile/models/test/test_state.dart';
import 'package:couple_mood_mobile/models/test/test_submit.dart';
import 'package:couple_mood_mobile/models/test/test_type.dart';
import 'package:couple_mood_mobile/services/api_client.dart';

class TestService {
  Future<List<TestType>> getListTest() async {
    final res = await ApiClient.request(
      "/PersonalityTest",
      method: HttpMethod.get,
    );
    try {
      final root = (res as Map).cast<String, dynamic>();
      final List<dynamic> data = (root['data'] as List).cast<dynamic>();
      return TestType.fromJsonList(data);
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách bài test: $e');
    }
  }

  Future<List<TestDetail>> getTestDetailById(String testId, String mode) async {
    final res = await ApiClient.request(
      "/PersonalityTest/$testId/questions",
      method: HttpMethod.get,
      query: {'mode': mode},
    );
    try {
      final root = (res as Map).cast<String, dynamic>();
      final List<dynamic> data = (root['data'] as List).cast<dynamic>();
      return TestDetail.fromJsonList(data);
    } catch (e) {
      throw Exception('Lỗi khi lấy chi tiết bài test: $e');
    }
  }

  Future<TestState> checkStateTest(String testId) async {
    final res = await ApiClient.request(
      "/PersonalityTest/$testId/state",
      method: HttpMethod.get,
    );
    try {
      final root = (res as Map).cast<String, dynamic>();
      final data = root['data'] as Map<String, dynamic>;
      return TestState.fromJson(data);
    } catch (e) {
      throw Exception('Lỗi khi kiểm tra trạng thái bài test: $e');
    }
  }

  Future<TestResult> submitTestAnswersTypeSubmit(
    String testId,
    TestSubmit testSubmit,
  ) async {
    final payload = testSubmit.toJson();
    try {
      final res = await ApiClient.request(
        "/PersonalityTest/$testId/submit",
        method: HttpMethod.post,
        data: payload,
      );
      final root = (res as Map).cast<String, dynamic>();
      final data = root['data'] as Map<String, dynamic>;
      return TestResult.fromJson(data["result"] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Lỗi khi nộp bài test: $e');
    }
  }

  Future<void> submitTestAnswersTypeSaveProgress(
    String testId,
    TestSubmit testSubmit,
  ) async {
    final payload = testSubmit.toJson();
    try {
      await ApiClient.request(
        "/PersonalityTest/$testId/submit",
        method: HttpMethod.post,
        data: payload,
      );
    } catch (e) {
      throw Exception('Lỗi khi lưu tiến trình bài test: $e');
    }
  }

  Future<String> getUserPersonality() async {
    final res = await ApiClient.request(
      "/PersonalityTest/me",
      method: HttpMethod.get,
    );
    try {
      final root = (res as Map).cast<String, dynamic>();
      final data = root['data'] as Map<String, dynamic>;
      return data['resultCode'] as String;
    } catch (e) {
      throw Exception('Lỗi khi lấy kết quả bài test: $e');
    }
  }
}
