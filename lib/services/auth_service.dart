import 'package:couple_mood_mobile/models/register_request.dart';
import 'package:couple_mood_mobile/models/session.dart';
import 'package:couple_mood_mobile/utils/session_storage.dart';
import 'api_client.dart';

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
      userId: data['userId'] as int?,
      gender: data['gender']?.toString(),
      avartarUrl: data['avartarUrl']?.toString() ?? data['imageUrl']?.toString(),
    );
    await SessionStorage.save(session);

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
}
