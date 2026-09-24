import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_provider.dart';
import '../../data/payment_repository.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(apiClient: ref.read(apiClientProvider));
});
