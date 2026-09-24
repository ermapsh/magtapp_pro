import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../../../subscription/presentation/widgets/subscription_bottom_sheet.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 32),

          // PROFILE AVATAR
          Center(
            child: CircleAvatar(
              radius: 40,
              child: Text(
                _getInitial(user?.email),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // EMAIL
          Center(
            child: Text(
              user?.email ?? 'Loading...',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),

          const SizedBox(height: 8),

          // PLAN
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: user?.subscription?.isPro == true
                    ? Colors.amber.shade100
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user?.subscription?.isPro == true ? 'MagTapp Pro' : 'Free Plan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: user?.subscription?.isPro == true
                      ? Colors.orange.shade800
                      : Colors.grey.shade700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),

          const Divider(),

          // PROFILE DETAILS
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile Details'),
            subtitle: Text(user?.email ?? 'View your profile information'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Profile details page later.
            },
          ),

          // SECURITY
          ListTile(
            leading: const Icon(Icons.workspace_premium_outlined),
            title: const Text('Subscription & Billing'),
            subtitle: Text(
              user?.subscription?.isPro == true
                  ? 'Manage your MagTapp Pro subscription'
                  : 'Upgrade from Free Plan',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const SubscriptionBottomSheet(),
              );
            },
          ),

          const Divider(),

          // LOGOUT
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              // Clear user profile state.
              ref.read(userProvider.notifier).clearProfile();

              // Clear JWT/session.
              await ref.read(authProvider.notifier).logout();

              if (!context.mounted) return;

              context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  String _getInitial(String? email) {
    if (email == null || email.isEmpty) {
      return 'U';
    }

    return email.substring(0, 1).toUpperCase();
  }
}
