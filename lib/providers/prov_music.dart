import 'dart:developer';

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
    if (!isMusicOn) return;
    audioMove.setReleaseMode(ReleaseMode.release);
    audioMove.play(AssetSource("sounds/move2.mp3"));
  }

  void key() {
    if (!isMusicOn) return;
    audioMove.setReleaseMode(ReleaseMode.release);
    audioMove.play(AssetSource("sounds/key.wav"));
  }

  void win() {
    if (!isMusicOn) return;
    audioMove.setReleaseMode(ReleaseMode.release);
    audioMove.play(AssetSource("sounds/win.mp3"));
  }

  void kill() {
    if (!isMusicOn) return;
    audioMove.setReleaseMode(ReleaseMode.release);
    audioMove.play(AssetSource("sounds/kill.wav"));
  }

  void buttonPressed() {
    if (!isMusicOn) return;
    audioMove.setReleaseMode(ReleaseMode.release);
    audioMove.play(AssetSource("sounds/button.wav"));
  }

  void playBackgroundMusic() {
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

  void pauseMusic() {
    audioBackground.pause();
    isMusicOn = false;
    notifyListeners();
  }

  void resumeMusic() {
    audioBackground.resume();
    isMusicOn = true;
    notifyListeners();
  }

  void stopMusic() async {
    await audioBackground.stop();
    isMusicOn = false;
    notifyListeners();
  }

  void disposeMusic() {
    log("stopping music");
    audioBackground.stop();
    audioBackground.dispose();
  }
}
