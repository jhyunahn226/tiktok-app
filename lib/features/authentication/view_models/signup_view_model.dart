import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/authentication/repos/authentication_repo.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;
  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp() async {
    final form = ref.read(signUpForm);

    state = await AsyncValue.guard(
      () async => _authRepo.emailSignUp(
        form["email"],
        form["password"],
      ),
    );
  }

  Future<void> signOut() async {
    state = await AsyncValue.guard(() async => _authRepo.signOut());
  }
}

final signUpForm = StateProvider((ref) => {});

final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
