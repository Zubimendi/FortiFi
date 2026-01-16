import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/user_profile_repository.dart';
import '../../data/models/user_profile_model.dart';

/// Provider for user profile repository
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository();
});

/// User profile state
class UserProfileState {
  final UserProfileModel? profile;
  final bool isLoading;
  final String? error;

  UserProfileState({
    this.profile,
    this.isLoading = false,
    this.error,
  });

  UserProfileState copyWith({
    UserProfileModel? profile,
    bool? isLoading,
    String? error,
  }) {
    return UserProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// User profile notifier
class UserProfileNotifier extends StateNotifier<UserProfileState> {
  final UserProfileRepository _repository;

  UserProfileNotifier(this._repository) : super(UserProfileState()) {
    loadProfile();
  }

  /// Load user profile
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final profile = await _repository.getProfile();
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Update user name
  Future<bool> updateName(String name) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _repository.updateName(name);
      if (success) {
        await loadProfile();
      }
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Update profile picture
  Future<bool> updateProfilePicture(String? imagePath) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _repository.updateProfilePicture(imagePath);
      if (success) {
        await loadProfile();
      }
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

/// User profile provider
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfileState>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return UserProfileNotifier(repository);
});
