import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/home/presentation/pages/main_page.dart';
import 'route_names.dart';

GoRouter createRouter(bool isLoggedIn) {
  debugPrint('[ROUTER] isLoggedIn: $isLoggedIn');

  return GoRouter(
    initialLocation: isLoggedIn ? RouteNames.home : RouteNames.login,

    routes: [
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: RouteNames.signup,
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const MainPage(),
      ),
    ],
  );
}
