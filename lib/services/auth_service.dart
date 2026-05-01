import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/change_password_request.dart';
import 'package:couple_mood_mobile/models/register_request.dart';
import 'package:couple_mood_mobile/models/reset_password_request.dart';
import 'package:couple_mood_mobile/models/session.dart';
import 'package:couple_mood_mobile/utils/session_storage.dart';
import 'package:flutter/widgets.dart';
import 'api_client.dart';
import 'package:couple_mood_mobile/services/notification_service.dart';

class AuthService {
  static Future<Session> login(String email, String password) async {
    final res = await ApiClient.request(
      '/Auth/login',
      method: HttpMethod.post,
      data: {'email': email, 'password': password, "rememberMe": true},
    );

    final root = (res as Map).cast<String, dynamic>();
    final data = (root['data'] as Map).cast<String, dynamic>();

    final accessToken = data['accessToken']?.toString() ?? '';
    final refreshToken = data['refreshToken']?.toString() ?? '';

    if (accessToken.isEmpty || refreshToken.isEmpty) {
      throw Exception('Thiếu token từ server');
    }
    final session = Session(
      accessToken: accessToken,
      refreshToken: refreshToken,
      gender: data['gender']?.toString(),
      avatarUrl: data['avatarUrl']?.toString(),
      fullName: data['fullName']?.toString(),
      dateOfBirth: data['dateOfBirth']?.toString(),
      inviteCode: data['inviteCode']?.toString(),
      balance: (data['balance'] as num?)?.toInt(),
      points: (data['points'] as num?)?.toInt(),
    );
    await SessionStorage.save(session);
    await NotificationService.sendTokenToServerAfterLogin();
    return session;
  }

  static Future<void> logout() async {
    await SessionStorage.clear();
  }

  static Future<bool> register(RegisterRequest request) async {
    final res = await ApiClient.request(
      "/Auth/register",
      method: HttpMethod.post,
      data: request.toJson(),
    );
    final root = (res as Map).cast<String, dynamic>();
    if (root['code'] == 200) {
      return true;
    } else {
      throw Exception(root['message']?.toString() ?? 'Đăng ký thất bại');
    }
  }

  static Future<Session> loginWithGoogle(String idToken) async {
    final res = await ApiClient.request(
      '/Auth/google-login-mobile',
      method: HttpMethod.post,
      data: {'idToken': idToken},
    );

    final root = (res as Map).cast<String, dynamic>();
    final data = (root['data'] as Map).cast<String, dynamic>();

    final accessToken = data['accessToken']?.toString() ?? '';
    final refreshToken = data['refreshToken']?.toString() ?? '';

    if (accessToken.isEmpty || refreshToken.isEmpty) {
      throw Exception('Thiếu token từ server');
    }

    final session = Session(
      accessToken: accessToken,
      refreshToken: refreshToken,
      gender: data['gender']?.toString(),
      avatarUrl: data['avatarUrl']?.toString(),
      fullName: data['fullName']?.toString(),
      dateOfBirth: data['dateOfBirth']?.toString(),
      inviteCode: data['inviteCode']?.toString(),
      balance: (data['balance'] as num?)?.toInt(),
      points: (data['points'] as num?)?.toInt(),
    );

    await SessionStorage.save(session);
    await NotificationService.sendTokenToServerAfterLogin();

    return session;
  }

  static Future<ApiResponse<void>> forgotPassword(String email) async {
    try {
      final res = await ApiClient.request(
        '/Auth/forgot-password',
        method: HttpMethod.post,
        data: {'email': email},
      );
      return ApiResponse<void>.fromJson(res, (json) {});
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi gửi yêu cầu đặt lại mật khẩu: $e');
    }
  }

  static Future<ApiResponse<void>> resetPassword(
    ResetPasswordRequest request,
  ) async {
    try {
      final res = await ApiClient.request(
        '/Auth/reset-password',
        method: HttpMethod.post,
        data: request.toJson(),
      );
      return ApiResponse<void>.fromJson(res, (json) {});
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi đặt lại mật khẩu: $e');
    }
  }

  static Future<ApiResponse<void>> changePassword(
    ChangePasswordRequest request,
  ) async {
    try {
      final res = await ApiClient.request(
        '/Auth/update-password',
        method: HttpMethod.post,
        data: request.toJson(),
      );
      return ApiResponse<void>.fromJson(res, (json) {});
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Lỗi khi đổi mật khẩu: $e');
    }
  }

  // sao BE tận 2 api verify
  // static Future<ApiResponse<void>> verifyOtp(
  //   String email,
  //   String otpCode,
  // ) async {
  //   final res = await ApiClient.request(
  //     '/Auth/verify-otp',
  //     method: HttpMethod.post,
  //     data: {"email": email, "otpCode": otpCode},
  //   );

  //   return ApiResponse<void>.fromJson(res, (json) {});
  // }

  static Future<ApiResponse<void>> sendRegistrationOtp(String email) async {
    final res = await ApiClient.request(
      '/Auth/send-registration-otp',
      method: HttpMethod.post,
      data: {"email": email},
    );

    return ApiResponse<void>.fromJson(res, (json) {});
  }

  static Future<ApiResponse<void>> verifyRegistrationOtp(
    String email,
    String otpCode,
  ) async {
    final res = await ApiClient.request(
      '/Auth/verify-registration-otp',
      method: HttpMethod.post,
      data: {"email": email, "otpCode": otpCode},
    );

    return ApiResponse<void>.fromJson(res, (json) {});
  }
}
