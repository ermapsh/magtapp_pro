import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/providers/auth_provider.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

class MagTappApp extends ConsumerWidget {
  const MagTappApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    debugPrint('[APP] isLoggedIn: ${authState.isLoggedIn}');

    return MaterialApp.router(
      title: 'MagTapp Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: createRouter(authState.isLoggedIn),
    );
  }
}
