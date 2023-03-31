import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/videos/models/video_model.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  List<VideoModel> _list = [
    VideoModel(title: "First video"),
  ];

  void uploadVideo() async {
    state = const AsyncValue.loading(); //TimelineViewModel을 로딩 상태로 만들기

    await Future.delayed(const Duration(seconds: 2)); //API 호출 및 응답 대기

    final newVideo = VideoModel(title: "${DateTime.now()}");
    _list = [..._list, newVideo];
    state = AsyncValue.data(
        _list); //AsyncNotifier에서는 이렇게 state를 업데이트 해야 함(로딩일수도있고 에러일수도있어서)
  }

  @override
  FutureOr<List<VideoModel>> build() async {
    await Future.delayed(const Duration(seconds: 5));
    return _list;
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
        () => TimelineViewModel());
