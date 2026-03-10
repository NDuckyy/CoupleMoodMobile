import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/paginated_response.dart';
import 'package:couple_mood_mobile/services/api_client.dart';
import 'package:couple_mood_mobile/models/challenge/challenge_item.dart';
import 'package:couple_mood_mobile/models/challenge/checkin_status.dart';
import 'package:couple_mood_mobile/models/challenge/couple_challenge.dart';

class ChallengeService {
  /// ==============================
  /// CHALLENGE TEMPLATE
  /// ==============================

  /// GET /api/couple-challenges/challenges
  /// Lấy danh sách challenge có thể tham gia
  static Future<ApiResponse<PaginatedResponse<ChallengeItem>>> getChallenges({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final res = await ApiClient.request(
        '/couple-challenges/challenges',
        method: HttpMethod.get,
        query: {'pageNumber': page, 'pageSize': pageSize},
      );

      return ApiResponse<PaginatedResponse<ChallengeItem>>.fromJson(
        res,
        (json) => PaginatedResponse<ChallengeItem>.fromJson(
          json,
          (e) => ChallengeItem.fromJson(e),
        ),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách challenge: $e');
    }
  }

  /// GET /api/couple-challenges/challenges/{challengeId}
  /// Lấy chi tiết challenge
  static Future<ApiResponse<ChallengeItem>> getChallengeDetail(
    int challengeId,
  ) async {
    try {
      final res = await ApiClient.request(
        '/couple-challenges/challenges/$challengeId',
        method: HttpMethod.get,
      );

      return ApiResponse<ChallengeItem>.fromJson(
        res,
        (json) => ChallengeItem.fromJson(json),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy chi tiết challenge: $e');
    }
  }

  /// POST /api/couple-challenges/challenges/{challengeId}/join
  /// Tham gia challenge
  static Future<ApiResponse<CoupleChallenge>> joinChallenge(
    int challengeId,
  ) async {
    try {
      final res = await ApiClient.request(
        '/couple-challenges/challenges/$challengeId/join',
        method: HttpMethod.post,
      );

      return ApiResponse<CoupleChallenge>.fromJson(
        res,
        (json) => CoupleChallenge.fromJson(json),
      );
    } catch (e) {
      throw Exception('Lỗi khi tham gia challenge: $e');
    }
  }

  /// ==============================
  /// COUPLE CHALLENGE
  /// ==============================

  /// GET /api/couple-challenges
  /// Lấy danh sách challenge đang thực hiện
  static Future<ApiResponse<PaginatedResponse<CoupleChallenge>>>
  getDoingChallenges({int page = 1, int pageSize = 10, String? status}) async {
    try {
      final res = await ApiClient.request(
        '/couple-challenges',
        method: HttpMethod.get,
        query: {
          'PageNumber': page,
          'PageSize': pageSize,
          if (status != null) 'Status': status,
        },
      );

      return ApiResponse<PaginatedResponse<CoupleChallenge>>.fromJson(
        res,
        (json) => PaginatedResponse<CoupleChallenge>.fromJson(
          json,
          (e) => CoupleChallenge.fromJson(e),
        ),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy challenge đang làm: $e');
    }
  }

  /// GET /api/couple-challenges/{coupleChallengeId}
  /// Lấy progress chi tiết challenge
  static Future<ApiResponse<CoupleChallenge>> getCoupleChallengeDetail(
    int coupleChallengeId,
  ) async {
    try {
      final res = await ApiClient.request(
        '/couple-challenges/$coupleChallengeId',
        method: HttpMethod.get,
      );

      return ApiResponse<CoupleChallenge>.fromJson(
        res,
        (json) => CoupleChallenge.fromJson(json),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy progress challenge: $e');
    }
  }

  /// POST /api/couple-challenges/{coupleChallengeId}/leave
  /// Rời challenge
  static Future<ApiResponse<void>> leaveChallenge(int coupleChallengeId) async {
    try {
      final res = await ApiClient.request(
        '/couple-challenges/$coupleChallengeId/leave',
        method: HttpMethod.post,
      );

      return ApiResponse<void>.fromJson(res, (_) => null);
    } catch (e) {
      throw Exception('Lỗi khi rời challenge: $e');
    }
  }

  /// ==============================
  /// CHECKIN
  /// ==============================

  /// GET /api/couple-challenges/checkin/today-status
  /// Kiểm tra user đã checkin hôm nay chưa
  static Future<ApiResponse<CheckinStatus>> getTodayCheckinStatus() async {
    try {
      final res = await ApiClient.request(
        '/couple-challenges/checkin/today-status',
        method: HttpMethod.get,
      );

      return ApiResponse<CheckinStatus>.fromJson(
        res,
        (json) => CheckinStatus.fromJson(json),
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy trạng thái check-in: $e');
    }
  }
}
