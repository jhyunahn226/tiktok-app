import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/videos/models/playback_config_model.dart';
import 'package:tiktok/features/videos/repos/playback_config_repo.dart';

/* [MVVM] ViewModel: View와 Model을 연결 */
class PlaybackConfigViewModel extends Notifier<PlaybackConfigModel> {
  final PlaybackConfigRepository _repository;

  PlaybackConfigViewModel(this._repository);

  //Setter
  void setMuted(bool value) {
    _repository.setMuted(value);
    state = PlaybackConfigModel(
      muted: value,
      autoplay: state.autoplay,
    );
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    state = PlaybackConfigModel(
      muted: state.muted,
      autoplay: value,
    );
  }

  @override
  PlaybackConfigModel build() {
    return PlaybackConfigModel(
      muted: _repository.isMuted(),
      autoplay: _repository.isAutoplay(),
    );
  }
}

final playbackConfigProvier =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  () => throw UnimplementedError(),
);

/*
Provider를 외부로 노출하기! 원래는 이렇게 해야함

final playbackConfigProvier =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  () => PlaybackConfigModel(),
);

그런데 PlaybackConfigModel을 호출할 때, _repository를 인자로 넣어줘야하는데,
_repository는 SharedPreferences를 사용하고,
main.dart에서 final preferences = await SharedPreferences.getInstance(); 을 호출하기 전까지는 정의될 수 없음

그래서 여기서는 먼저 일단 UnimplementedError를 던지고,
main.dart에서 final preferences = await SharedPreferences.getInstance(); 를 호출한 다음에
playbackConfigProvider를 재정의(override)하는 방식으로 구현함.

SharedPreferences를 사용하기 때문에 적용되는 특수한 케이스!
*/