import 'package:couple_mood_mobile/models/test/test_detail.dart';
import 'package:couple_mood_mobile/models/test/test_submit.dart';
import 'package:couple_mood_mobile/models/test/test_type.dart';
import 'package:couple_mood_mobile/services/test_service.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/foundation.dart';

class TestProvider extends ChangeNotifier {
  final TestService _testService = TestService();
  bool isLoading = false;
  String? error;
  List<TestType> tests = [];
  List<TestDetail> testDetails = [];

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
      return testState.state;
    } catch (e) {
      throw Exception('Lỗi khi lấy trạng thái bài test: $e');
    }
  }

  Future<void> submitTestAnswers(String testId, TestSubmit answers) async {
    try {
      await _testService.submitTestAnswers(testId, answers);
    } catch (e) {
      throw Exception('Lỗi khi nộp bài test: $e');
    }
  }
}
