import 'package:shared_preferences/shared_preferences.dart';

/* [MVVM] Repository: 데이터를 읽거나 쓰는 역할 */
class VideoPlaybackConfigRepository {
  static const String _muted = "muted";
  static const String _autoplay = "autoplay";

  final SharedPreferences _preferences;

  VideoPlaybackConfigRepository(this._preferences);

  Future<void> setMuted(bool value) async {
    _preferences.setBool(_muted, value);
  }

  Future<void> setAutoplay(bool value) async {
    _preferences.setBool(_autoplay, value);
  }

  bool isMuted() {
    return _preferences.getBool(_muted) ?? false;
  }

  bool isAutoplay() {
    return _preferences.getBool(_autoplay) ?? false;
  }
}
