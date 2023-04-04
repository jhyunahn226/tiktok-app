import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/users/models/user_profile_model.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  @override
  FutureOr<UserProfileModel> build() {
    return UserProfileModel.empty();
  }

  Future<void> createAccount(UserCredential credential) async {
    if (credential.user == null) throw Exception("Account not created");
    state = AsyncValue.data(
      UserProfileModel(
        uid: credential.user!.uid,
        name: credential.user!.displayName ?? "Anonymous",
        email: credential.user!.email ?? "Anonymous",
        bio: "undefined",
        link: "undefined",
      ),
    );
  }
}

final usersProvider = AsyncNotifierProvider(
  () => UsersViewModel(),
);
