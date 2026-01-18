import 'package:dio/dio.dart';
import '../utils/session_storage.dart';

enum HttpMethod { get, post, put, delete }

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://couplemood.ooguy.com/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static Future<dynamic> request(
  String path, {
  required HttpMethod method,
  Map<String, dynamic>? data,
  Map<String, dynamic>? query,
}) async {
  try {
    final session = await SessionStorage.load();
    final token = session?.accessToken;

    final res = await _dio.request(
      path,
      data: data,
      queryParameters: query,
      options: Options(
        method: method.name.toUpperCase(),
        headers: {
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      ),
    );

    return res.data;
  } on DioException catch (e) {
    throw Exception(
      (e.response?.data is Map && e.response?.data['message'] != null)
          ? e.response?.data['message'].toString()
          : (e.message ?? 'Lỗi kết nối server'),
    );
  } catch (e) {
    rethrow;
  }
}

}
