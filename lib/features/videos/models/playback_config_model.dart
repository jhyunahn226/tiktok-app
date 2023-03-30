/* [MVVM] Model: 데이터의 구조를 정의 */

class PlaybackConfigModel {
  bool muted;
  bool autoPlay;

  PlaybackConfigModel({
    required this.muted,
    required this.autoPlay,
  });
}
