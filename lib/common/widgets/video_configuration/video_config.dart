import 'package:flutter/material.dart';

class VideoConfig extends ChangeNotifier {
  bool autoMute = true;
  void toggleAutoMute() {
    autoMute = !autoMute;
    notifyListeners();
  }
}

final videoConfig = VideoConfig();
