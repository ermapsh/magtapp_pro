import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../order/presentation/providers/order_provider.dart';

class SubscriptionBottomSheet extends ConsumerWidget {
  const SubscriptionBottomSheet({super.key});

  Future<void> _createOrder(
    BuildContext context,
    WidgetRef ref, {
    required int amount,
    required String subscriptionPlan,
  }) async {
    try {
      debugPrint('[ORDER] Creating order...');
      debugPrint('[ORDER] Amount: ₹$amount');
      debugPrint('[ORDER] Plan: $subscriptionPlan');

      final order = await ref
          .read(orderRepositoryProvider)
          .createOrder(amount: amount, subscriptionPlan: subscriptionPlan);

      debugPrint('[ORDER] Order created successfully');
      debugPrint('[ORDER] Order ID: ${order.id}');
      debugPrint('[ORDER] Status: ${order.status}');

      if (!context.mounted) return;

      // Close the bottom sheet and return order details
      Navigator.pop(context, {
        'orderId': order.id,
        'amount': amount,
        'subscriptionPlan': subscriptionPlan,
      });
    } catch (e, stackTrace) {
      debugPrint('[ORDER] Failed to create order');
      debugPrint('[ORDER] Error: $e');
      debugPrint('[ORDER] Stack trace: $stackTrace');

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to create order. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 24),

            const Icon(Icons.workspace_premium, size: 56),

            const SizedBox(height: 12),

            const Text(
              'You are on Free Plan',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              'Upgrade to MagTapp Pro to unlock more features.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _PlanCard(
                    title: 'Pro',
                    price: '₹99',
                    subtitle: 'per month',
                    onTap: () {
                      _createOrder(
                        context,
                        ref,
                        amount: 99,
                        subscriptionPlan: 'PRO_MONTHLY_99',
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _PlanCard(
                    title: 'Pro Plus',
                    price: '₹299',
                    subtitle: 'per month',
                    onTap: () {
                      _createOrder(
                        context,
                        ref,
                        amount: 299,
                        subscriptionPlan: 'PRO_MONTHLY_299',
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Maybe Later'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String subtitle;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              price,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                child: const Text('Upgrade'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
