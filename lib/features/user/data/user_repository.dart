import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

class UserProfile {
  final String id;
  final String email;
  final SubscriptionInfo? subscription;

  UserProfile({required this.id, required this.email, this.subscription});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      subscription: json['subscription'] != null
          ? SubscriptionInfo.fromJson(
              Map<String, dynamic>.from(json['subscription']),
            )
          : null,
    );
  }
}

class SubscriptionInfo {
  final bool isPro;

  SubscriptionInfo({required this.isPro});

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    return SubscriptionInfo(isPro: json['isPro'] == true);
  }
}

class UserRepository {
  final ApiClient _apiClient;

  UserRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<UserProfile> getProfile() async {
    final response = await _apiClient.get(ApiEndpoints.user);

    final data = response.data['data'];

    if (data == null) {
      throw Exception('User profile was not returned by server');
    }

    return UserProfile.fromJson(Map<String, dynamic>.from(data));
  }
}
