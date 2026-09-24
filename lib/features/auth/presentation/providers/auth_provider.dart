import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_provider.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/auth_repository.dart';

class AuthState {
  final String? userId;
  final String? accessToken;
  final bool isLoggedIn;

  const AuthState({this.userId, this.accessToken, this.isLoggedIn = false});

  AuthState copyWith({String? userId, String? accessToken, bool? isLoggedIn}) {
    return AuthState(
      userId: userId ?? this.userId,
      accessToken: accessToken ?? this.accessToken,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  late final TokenStorage _tokenStorage;

  @override
  AuthState build() {
    _tokenStorage = TokenStorage();
    return const AuthState();
  }

  Future<void> initialize() async {
    debugPrint('[AUTH] Initializing auth...');

    final token = await _tokenStorage.getAccessToken();

    debugPrint('[AUTH] Token exists: ${token != null && token.isNotEmpty}');

    if (token == null || token.isEmpty) {
      debugPrint('[AUTH] No token found');
      return;
    }

    state = state.copyWith(accessToken: token, isLoggedIn: true);

    debugPrint('[AUTH] Session restored');
    debugPrint('[AUTH] isLoggedIn: ${state.isLoggedIn}');
  }

  Future<void> setSession({required String accessToken, String? userId}) async {
    await _tokenStorage.saveAccessToken(accessToken);

    state = state.copyWith(
      accessToken: accessToken,
      userId: userId,
      isLoggedIn: true,
    );
  }

  Future<void> logout() async {
    await _tokenStorage.clearAccessToken();

    state = const AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(apiClient: ref.read(apiClientProvider));
});
