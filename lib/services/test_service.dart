import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/test/test_detail.dart';
import 'package:couple_mood_mobile/models/test/test_result.dart';
import 'package:couple_mood_mobile/models/test/test_state.dart';
import 'package:couple_mood_mobile/models/test/test_submit.dart';
import 'package:couple_mood_mobile/models/test/test_type.dart';
import 'package:couple_mood_mobile/services/api_client.dart';

class TestService {
  Future<ApiResponse<List<TestType>>> getListTest() async {
    try {
      final res = await ApiClient.request(
        "/PersonalityTest",
        method: HttpMethod.get,
      );
      return ApiResponse<List<TestType>>.fromJson(
        res,
        (json) => TestType.fromJsonList(json),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách bài test: $e');
    }
  }

  Future<ApiResponse<List<TestDetail>>> getTestDetailById(
    String testId,
    String mode,
  ) async {
    try {
      final res = await ApiClient.request(
        "/PersonalityTest/$testId/questions",
        method: HttpMethod.get,
        query: {'mode': mode},
      );
      return ApiResponse<List<TestDetail>>.fromJson(
        res,
        (json) => TestDetail.fromJsonList(json),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy chi tiết bài test: $e');
    }
  }

  Future<ApiResponse<TestState>> checkStateTest(String testId) async {
    try {
      final res = await ApiClient.request(
        "/PersonalityTest/$testId/state",
        method: HttpMethod.get,
      );
      return ApiResponse<TestState>.fromJson(
        res,
        (json) => TestState.fromJson(json),
      );
    } catch (e) {
      throw Exception('Lỗi khi kiểm tra trạng thái bài test: $e');
    }
  }

  Future<ApiResponse<TestResponse>> submitTestAnswersTypeSubmit(
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
      return ApiResponse<TestResponse>.fromJson(
        res,
        (json) => TestResponse.fromJson(json),
      );
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
