import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

class OrderResponse {
  final String id;
  final String status;

  OrderResponse({required this.id, required this.status});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}

class OrderRepository {
  final ApiClient _apiClient;

  OrderRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<OrderResponse> createOrder({
    required int amount,
    required String subscriptionPlan,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.orders,
      data: {
        'amount': {'currency': 'INR', 'amountUnits': amount},
        'subscriptionPlan': subscriptionPlan,
        'notes': {'user_phone': '9876543210'},
        'receipt': 'order-${DateTime.now().millisecondsSinceEpoch}',
      },
    );

    final data = response.data['data'];

    if (data == null) {
      throw Exception('Order was not created');
    }

    return OrderResponse.fromJson(Map<String, dynamic>.from(data));
  }
}
