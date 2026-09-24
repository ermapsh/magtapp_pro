import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

class PaymentResponse {
  final String id;
  final String orderId;
  final String paymentStatus;

  PaymentResponse({
    required this.id,
    required this.orderId,
    required this.paymentStatus,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      id: json['id']?.toString() ?? '',
      orderId: json['orderId']?.toString() ?? '',
      paymentStatus: json['paymentStatus']?.toString() ?? '',
    );
  }
}

class PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<PaymentResponse> initiatePayment({required String orderId}) async {
    final response = await _apiClient.post(
      ApiEndpoints.payments,
      data: {
        'orderId': orderId,
        'method': 'NET_BANKING',
        'methodDetails': {'card': '1234', 'bank': 'MOCK'},
      },
    );

    final data = response.data['data'];

    if (data == null) {
      throw Exception('Payment response was not returned');
    }

    return PaymentResponse.fromJson(Map<String, dynamic>.from(data));
  }
}
