import 'package:dio/dio.dart';

import '../storage/secure_storage.dart';
import 'api_config.dart';

class ApiClient {
  final TokenStorage _tokenStorage;

  late final Dio dio;

  ApiClient({TokenStorage? tokenStorage})
    : _tokenStorage = tokenStorage ?? TokenStorage() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    const publicEndpoints = {'/api/v1/auth/login', '/api/v1/auth/signup'};

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final isPublicEndpoint = publicEndpoints.contains(options.path);

          if (!isPublicEndpoint) {
            final token = await _tokenStorage.getAccessToken();

            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          handler.next(options);
        },

        onResponse: (response, handler) {
          handler.next(response);
        },

        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _tokenStorage.clearAccessToken();
          }

          handler.next(error);
        },
      ),
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.post<T>(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.put<T>(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.delete<T>(path, data: data, queryParameters: queryParameters);
  }
}
