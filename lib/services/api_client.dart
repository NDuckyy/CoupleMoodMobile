import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/session_storage.dart';

enum HttpMethod { get, post, put, delete, patch }

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
      connectTimeout: const Duration(seconds: 100),
      receiveTimeout: const Duration(seconds: 100),
    ),
  );

  static bool _inited = false;

  static void _init() {
    if (_inited) return;
    _inited = true;

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );
  }

  static Future<dynamic> request(
    String path, {
    required HttpMethod method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    _init();
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
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status != null && status < 500,
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

  static Future<dynamic> upload(
    String path, {
    required HttpMethod method,
    required FormData data,
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
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status != null && status < 500,
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

  static Future<dynamic> requestForContext({
    required HttpMethod method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    _init();
    try {
      final session = await SessionStorage.load();
      final token = session?.accessToken;
      final res = await _dio.request(
        dotenv.env['CONTEXT_URL']!,
        data: data,
        queryParameters: query,
        options: Options(
          method: method.name.toUpperCase(),
          headers: {
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer ${dotenv.env['TOKEN_KEY']!}',
          },
          validateStatus: (status) => status != null && status < 500,
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

  static Future<dynamic> autoComplete({
    required HttpMethod method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    _init();
    try {
      final session = await SessionStorage.load();
      final token = session?.accessToken;
      final res = await _dio.request(
        dotenv.env['AUTO_COMPLETE_URL']!,
        data: data,
        queryParameters: query,
        options: Options(
          method: method.name.toUpperCase(),
          headers: {
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer ${dotenv.env['TOKEN_KEY']!}',
          },
          validateStatus: (status) => status != null && status < 500,
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
