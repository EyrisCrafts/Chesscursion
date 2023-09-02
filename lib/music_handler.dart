import 'package:chesscursion_creator/providers/prov_music.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MusicHandler extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      GetIt.I<ProvMusic>().resumeMusic();
    } else {
      GetIt.I<ProvMusic>().pauseMusic();
    } 
  }
}
