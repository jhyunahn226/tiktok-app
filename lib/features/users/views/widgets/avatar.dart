import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok/features/users/view_models/avatar_view_model.dart';

class Avatar extends ConsumerWidget {
  final String uid;
  final String username;
  final bool hasAvatar;

  const Avatar({
    super.key,
    required this.uid,
    required this.username,
    required this.hasAvatar,
  });

  Future<void> _onAvatarTap(WidgetRef ref) async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );
    if (xfile != null) {
      final file = File(xfile.path);
      ref.read(avatarProvider.notifier).uploadAvatar(file);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(avatarProvider).isLoading;
    return GestureDetector(
      onTap: isLoading ? null : () => _onAvatarTap(ref),
      child: isLoading
          ? Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(),
            )
          : CircleAvatar(
              radius: 50,
              foregroundImage: hasAvatar
                  ? NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/tiktok-flutter-beem.appspot.com/o/avatars%2F$uid?alt=media&haha=${DateTime.now().toString()}", //URL이 변하지 않으면 기본적으로 이미지를 캐싱함. URL을 바꿔서 플러터를 속이고 이미지를 캐싱하지 않도록 하자!
                    )
                  : null,
              child: Text(username),
            ),
    );
  }
}
