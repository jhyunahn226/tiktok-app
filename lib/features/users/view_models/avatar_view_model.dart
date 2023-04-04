import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok/features/users/repos/user_repo.dart';
import 'package:tiktok/features/users/view_models/users_view_model.dart';

class AvatarViewModel extends AsyncNotifier<void> {
  late final UserRepository _userRepository;

  @override
  FutureOr<void> build() {
    _userRepository = ref.read(userRepo);
  }

  Future<void> uploadAvatar(File file) async {
    state = const AsyncValue.loading();
    final fileName = ref.read(authRepo).user!.uid;
    state = await AsyncValue.guard(() async {
      await _userRepository.uploadAvatar(file, fileName);
      await ref.read(usersProvider.notifier).onAvatarUpload();
    });
  }
}

final avatarProvider = AsyncNotifierProvider<AvatarViewModel, void>(
  () => AvatarViewModel(),
);
