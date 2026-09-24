import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../settings/presentation/pages/settings_page.dart';
import '../../../subscription/presentation/widgets/subscription_bottom_sheet.dart';
import '../../../user/presentation/providers/user_provider.dart';

import 'home_page.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [HomePage(), SettingsPage()];

  bool _isPro = false;
  bool _subscriptionModalShown = false;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    try {
      await ref.read(userProvider.notifier).loadProfile();

      if (!mounted) return;

      final profile = ref.read(userProvider);

      setState(() {
        _isPro = profile?.subscription?.isPro == true;
      });

      if (!_isPro) {
        _scheduleSubscriptionModal();
      }
    } catch (e) {
      debugPrint('[USER] Failed to load profile: $e');
    }
  }

  void _scheduleSubscriptionModal() {
    Future.delayed(const Duration(seconds: 5), () async {
      if (!mounted) return;
      if (_isPro) return;
      if (_subscriptionModalShown) return;

      _subscriptionModalShown = true;

      final result = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const SubscriptionBottomSheet(),
      );

      debugPrint('[SUBSCRIPTION] Bottom sheet result: $result');

      if (!mounted) return;
      if (result == null) return;

      debugPrint(
        '[PAYMENT] Navigating to payment screen: ${result['orderId']}',
      );

      context.push('/payment', extra: result);
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
