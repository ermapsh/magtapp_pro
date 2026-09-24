import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({required this._apiClient});

  Future<String> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    final data = response.data['data'];

    final accessToken = data['accessToken'];

    if (accessToken == null || accessToken.toString().isEmpty) {
      throw Exception('Access token was not returned by server');
    }

    return accessToken.toString();
  }

  Future<({String userId, String accessToken})> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.signup,
      data: {'name': name, 'email': email, 'password': password},
    );

    final data = response.data['data'];

    final userId = data['id'];
    final accessToken = data['accessToken'];

    if (userId == null || userId.toString().isEmpty) {
      throw Exception('User ID was not returned by server');
    }

    if (accessToken == null || accessToken.toString().isEmpty) {
      throw Exception('Access token was not returned by server');
    }

    return (userId: userId.toString(), accessToken: accessToken.toString());
  }
}
