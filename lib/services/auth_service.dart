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
      cometChatUid: data['cometChatUid']?.toString(),
      cometChatAuthToken: data['cometChatAuthToken']?.toString(),
      gender: data['gender']?.toString(),
    );
    await SessionStorage.save(session);

    return session;
  }
  
}
