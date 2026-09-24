import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  await container.read(authProvider.notifier).initialize();

  runApp(
    UncontrolledProviderScope(container: container, child: const MagTappApp()),
  );
}
