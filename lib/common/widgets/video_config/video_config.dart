import 'package:flutter/material.dart';

class VideoConfig extends ChangeNotifier {
  bool isMuted = false;
  bool isAutoplay = false;

  void toggleIsMuted() {
    isMuted = !isMuted;
    notifyListeners();
  }

  void toogleAutoplay() {
    isAutoplay = !isAutoplay;
    notifyListeners();
  }
}
