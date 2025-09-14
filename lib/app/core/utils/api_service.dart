import 'package:dio/dio.dart';

class ApiService {
  ApiService._internal();
  static final ApiService instance = ApiService._internal();

  factory ApiService() => instance;

  final _baseUrl =
      'https://fcm.googleapis.com/v1/projects/chat-app-c2a84/messages:send';
  final _multicastUrl =
      'https://fcm.googleapis.com/v1/projects/chat-app-c2a84/messages:sendMulticast';

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  /// Send single notification
  Future<Map<String, dynamic>> post({
    required String accessToken,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _dio.post(
        _baseUrl,
        data: body,
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.data ?? {};
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw DioException(
          requestOptions: e.requestOptions,
          error: 'Invalid device token or token expired',
          type: DioExceptionType.badResponse,
        );
      }
      rethrow;
    }
  }

  /// Send multicast notification (to multiple tokens)
  Future<Map<String, dynamic>> postMulticast({
    required String accessToken,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _dio.post(
        _multicastUrl,
        data: body,
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.data ?? {};
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw DioException(
          requestOptions: e.requestOptions,
          error: 'Invalid request format or tokens',
          type: DioExceptionType.badResponse,
        );
      }
      rethrow;
    }
  }

  /// Send notification to topic
  Future<Map<String, dynamic>> postToTopic({
    required String accessToken,
    required String topic,
    required Map<String, dynamic> notificationData,
  }) async {
    try {
      final body = {
        "message": {
          "topic": topic,
          ...notificationData,
        }
      };

      final response = await _dio.post(
        _baseUrl,
        data: body,
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.data ?? {};
    } on DioException {
      rethrow;
    }
  }
}
