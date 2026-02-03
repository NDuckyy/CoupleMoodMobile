import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/test/test_detail.dart';
import 'package:couple_mood_mobile/models/test/test_result.dart';
import 'package:couple_mood_mobile/models/test/test_submit.dart';
import 'package:couple_mood_mobile/models/test/test_type.dart';
import 'package:couple_mood_mobile/services/test_service.dart';
import 'package:flutter/foundation.dart';

class TestProvider extends ChangeNotifier {
  final TestService _testService = TestService();
  bool isLoading = false;
  String? error;
  ApiResponse<List<TestType>> tests = ApiResponse(
    message: '',
    code: 0,
    data: [],
  );
  ApiResponse<List<TestDetail>> testDetails = ApiResponse(
    message: '',
    code: 0,
    data: [],
  );
  ApiResponse<TestResponse>? _testResult;

  TestResponse? get testResult => _testResult?.data;

  Future<void> fetchTestList() async {
    if (isLoading) return;
    isLoading = true;
    notifyListeners();
    try {
      tests = await _testService.getListTest();
      isLoading = false;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTestDetails(String testId, String mode) async {
    if (isLoading) return;
    isLoading = true;
    notifyListeners();
    try {
      testDetails = await _testService.getTestDetailById(testId, mode);
      isLoading = false;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> checkStateTest(String testId) async {
    try {
      final testState = await _testService.checkStateTest(testId);
      return testState.data!.state;
    } catch (e) {
      throw Exception('Lỗi khi lấy trạng thái bài test: $e');
    }
  }

  Future<void> submitTestAnswers(String testId, TestSubmit answers) async {
    try {
      if (answers.action == "SUBMIT") {
        _testResult = await _testService.submitTestAnswersTypeSubmit(
          testId,
          answers,
        );
        if (_testResult?.code != 200 || _testResult?.data == null) {
          error = _testResult?.message ?? 'Lỗi không xác định khi nộp bài test';
          _testResult = null;
        }
      } else {
        await _testService.submitTestAnswersTypeSaveProgress(testId, answers);
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      _testResult = null;
    } finally {
      notifyListeners();
    }
  }

  Future<String> getUserPersonality() async {
    try {
      isLoading = true;
      notifyListeners();
      return await _testService.getUserPersonality();
    } catch (e) {
      throw Exception('Lỗi khi lấy tính cách người dùng: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
