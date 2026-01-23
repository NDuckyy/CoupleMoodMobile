import 'package:couple_mood_mobile/models/test.dart';
import 'package:couple_mood_mobile/services/test_service.dart';
import 'package:flutter/foundation.dart';



class TestProvider extends ChangeNotifier {
  final TestService _testService = TestService();
  bool isLoading = false;
  String? error;
  List<Test> tests = [];
  Future<void> fetchTestList() async {
    if (isLoading) return;
    isLoading = true;
    notifyListeners();
    try {
      print('Fetching test list...');
      tests = await _testService.getListTest();
      isLoading = false;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
