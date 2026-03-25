import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/paginated_response.dart';
import 'package:couple_mood_mobile/models/report/report_target_type.dart';
import 'package:couple_mood_mobile/models/report/report_type.dart';
import 'package:couple_mood_mobile/services/api_client.dart';

class ReportService {
  /// GET report types
  static Future<ApiResponse<PaginatedResponse<ReportType>>> getReportTypes({
    int page = 1,
    int pageSize = 20,
    bool? isActive,
  }) async {
    try {
      final res = await ApiClient.request(
        '/ReportType',
        method: HttpMethod.get,
        query: {
          'page': page,
          'pageSize': pageSize,
          if (isActive != null) 'isActive': isActive,
        },
      );

      return ApiResponse<PaginatedResponse<ReportType>>.fromJson(
        res,
        (json) => PaginatedResponse<ReportType>.fromJson(
          json,
          (e) => ReportType.fromJson(e),
        ),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy report types: $e');
    }
  }

  /// CREATE report
  static Future<ApiResponse<void>> createReport({
    required int reportTypeId,
    required ReportTargetType targetType,
    required int targetId,
    String? reason,
  }) async {
    try {
      final res = await ApiClient.request(
        '/Report',
        method: HttpMethod.post,
        data: {
          "reportTypeId": reportTypeId,
          "targetType": targetType.value,
          "targetId": targetId,
          "reason": reason ?? "",
        },
      );

      return ApiResponse<void>.fromJson(res, (_) => null);
    } catch (e) {
      throw Exception('Lỗi khi gửi report: $e');
    }
  }
}
