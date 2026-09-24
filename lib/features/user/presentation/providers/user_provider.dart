import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_provider.dart';
import '../../data/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(apiClient: ref.read(apiClientProvider));
});

final userProvider = NotifierProvider<UserNotifier, UserProfile?>(
  UserNotifier.new,
);

class UserNotifier extends Notifier<UserProfile?> {
  @override
  UserProfile? build() {
    return null;
  }

  Future<void> loadProfile() async {
    final profile = await ref.read(userRepositoryProvider).getProfile();

    state = profile;
  }

  void clearProfile() {
    state = null;
  }
}
