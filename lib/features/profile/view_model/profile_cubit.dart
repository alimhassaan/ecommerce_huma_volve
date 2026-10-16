import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/dummy_data.dart';
import '../../../core/storage/secure_storage.dart';

sealed class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile user;

  ProfileLoaded(this.user);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileLoading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final profile = await SecureStorage.getProfile();
      emit(
        ProfileLoaded(
          UserProfile(
            name: profile['name'] ?? 'Guest',
            email: profile['email'] ?? '',
            profilePictureUrl: profile['avatar'] ?? '',
          ),
        ),
      );
    } catch (error) {
      emit(ProfileError('Could not load your profile: $error'));
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    String? avatar,
  }) async {
    final current = state;
    if (current is! ProfileLoaded) {
      throw StateError('Profile is not loaded yet.');
    }

    final updatedProfile = UserProfile(
      name: name.trim(),
      email: email.trim(),
      profilePictureUrl: avatar ?? current.user.profilePictureUrl,
    );
    await SecureStorage.saveProfile(
      name: updatedProfile.name,
      email: updatedProfile.email,
      avatar: updatedProfile.profilePictureUrl,
    );
    emit(ProfileLoaded(updatedProfile));
  }

  Future<void> logout() async {
    await SecureStorage.deleteTokens();
  }
}
