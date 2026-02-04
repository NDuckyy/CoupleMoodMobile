import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/dateplan/date_plan_response.dart';
import 'package:couple_mood_mobile/services/api_client.dart';

class DatePlanService {
  static Future<ApiResponse<DatePlanPageResult>> getDatePlans({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final res = await ApiClient.request(
        '/DatePlan?pageNumber=$pageNumber&pageSize=$pageSize',
        method: HttpMethod.get,
      );
      return ApiResponse<DatePlanPageResult>.fromJson(
        res,
        (json) => DatePlanPageResult.fromJson(json),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách kế hoạch hẹn hò: $e');
    }
  }
}
