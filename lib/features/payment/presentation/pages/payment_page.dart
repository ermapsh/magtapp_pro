import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/payment_provider.dart';
import '../../../user/presentation/providers/user_provider.dart';

class PaymentPage extends ConsumerStatefulWidget {
  final String orderId;
  final int amount;
  final String subscriptionPlan;

  const PaymentPage({
    super.key,
    required this.orderId,
    required this.amount,
    required this.subscriptionPlan,
  });

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

enum _PaymentState { idle, processing, success, failed }

class _PaymentPageState extends ConsumerState<PaymentPage> {
  _PaymentState _paymentState = _PaymentState.idle;

  Future<void> _pay() async {
    if (_paymentState == _PaymentState.processing) {
      return;
    }

    setState(() {
      _paymentState = _PaymentState.processing;
    });

    try {
      debugPrint('[PAYMENT] Starting payment...');
      debugPrint('[PAYMENT] Order ID: ${widget.orderId}');
      debugPrint('[PAYMENT] Amount: ₹${widget.amount}');
      debugPrint('[PAYMENT] Plan: ${widget.subscriptionPlan}');

      final payment = await ref
          .read(paymentRepositoryProvider)
          .initiatePayment(orderId: widget.orderId);

      debugPrint('[PAYMENT] Payment ID: ${payment.id}');
      debugPrint('[PAYMENT] Payment status: ${payment.paymentStatus}');

      if (!mounted) return;

      if (payment.paymentStatus == 'CAPTURED') {
        debugPrint('[PAYMENT] Payment captured');
        debugPrint('[USER] Refreshing user profile...');

        await ref.read(userProvider.notifier).loadProfile();

        if (!mounted) return;

        final profile = ref.read(userProvider);

        debugPrint(
          '[USER] Profile refreshed. isPro: ${profile?.subscription?.isPro}',
        );

        setState(() {
          _paymentState = _PaymentState.success;
        });

        return;
      }

      setState(() {
        _paymentState = _PaymentState.failed;
      });
    } catch (e, stackTrace) {
      debugPrint('[PAYMENT] Payment failed');
      debugPrint('[PAYMENT] Error: $e');
      debugPrint('[PAYMENT] Stack trace: $stackTrace');

      if (!mounted) return;

      setState(() {
        _paymentState = _PaymentState.failed;
      });
    }
  }

  void _continueToApp() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    switch (_paymentState) {
      case _PaymentState.processing:
        return _buildProcessingScreen();

      case _PaymentState.success:
        return _buildSuccessScreen();

      case _PaymentState.failed:
        return _buildFailedScreen();

      case _PaymentState.idle:
        return _buildPaymentScreen();
    }
  }

  Widget _buildPaymentScreen() {
    final planName = widget.subscriptionPlan == 'PRO_MONTHLY_99'
        ? 'MagTapp Pro'
        : 'MagTapp Pro Plus';

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complete your payment',
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 32),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    '₹${widget.amount}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Monthly subscription',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Payment method',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.account_balance),
                  SizedBox(width: 12),
                  Expanded(child: Text('Net Banking')),
                  Icon(Icons.check_circle),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _pay,
                child: Text(
                  'Pay ₹${widget.amount}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingScreen() {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 56,
                  height: 56,
                  child: CircularProgressIndicator(strokeWidth: 4),
                ),

                const SizedBox(height: 32),

                const Text(
                  'Processing payment',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Text(
                  'Please wait while we confirm your payment.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 24),

                Text(
                  '₹${widget.amount}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Order ID: ${widget.orderId}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessScreen() {
    final planName = widget.subscriptionPlan == 'PRO_MONTHLY_99'
        ? 'MagTapp Pro'
        : 'MagTapp Pro Plus';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle, size: 88),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Payment successful!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Text(
                  '$planName is now active.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 24),

                Text(
                  '₹${widget.amount} paid',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Your Pro benefits are now available.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _continueToApp,
                    child: const Text(
                      'Continue to MagTapp',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFailedScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 72),

              const SizedBox(height: 24),

              const Text(
                'Payment failed',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Text(
                'We could not complete your payment. Please try again.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _paymentState = _PaymentState.idle;
                    });
                  },
                  child: const Text('Try Again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
