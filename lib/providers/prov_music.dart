import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class ProvMusic extends ChangeNotifier {
  bool isMusicOn = false;
  late AudioPlayer audioBackground;
  late AudioCache audioCacheBackground;

  late AudioPlayer audioMove;
  late AudioCache audioCacheMove;

  ProvMusic() {
    audioCacheBackground = AudioCache();
    audioBackground = AudioPlayer();
    audioCacheMove = AudioCache();
    audioMove = AudioPlayer();
  }

  void move() {
    audioMove.setReleaseMode(ReleaseMode.release);
    audioMove.play(AssetSource("sounds/move.wav"));
  }
  
  void key() {
    audioMove.setReleaseMode(ReleaseMode.release);
    audioMove.play(AssetSource("sounds/key.wav"));
  }

  void win() {
    audioMove.setReleaseMode(ReleaseMode.release);
    audioMove.play(AssetSource("sounds/win.mp3"));
  }

  void kill() {
    audioMove.setReleaseMode(ReleaseMode.release);
    audioMove.play(AssetSource("sounds/kill.wav"));
  }

  void buttonPressed() {
    audioMove.setReleaseMode(ReleaseMode.release);
    audioMove.play(AssetSource("sounds/button.wav"));
  }

  void playBackgroundMusic() {
    if (isMusicOn) return;
    isMusicOn = true;
    audioBackground.setReleaseMode(ReleaseMode.loop);
    audioBackground.play(AssetSource("sounds/background.mp3"));
    notifyListeners();
  }

  void toggleMusic() {
    if (isMusicOn) {
      stopMusic();
    } else {
      playBackgroundMusic();
    }
  }

  void stopMusic() async {
    await audioBackground.stop();
    isMusicOn = false;
    notifyListeners();
  }
}
