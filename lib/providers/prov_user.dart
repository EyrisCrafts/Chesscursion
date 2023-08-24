import 'package:chesscursion_creator/services/service_local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProvUser extends ChangeNotifier {
  int levelsCompleted = 0;

  void init() {
    levelsCompleted = GetIt.I<ServiceLocalStorage>().getLevelsCompleted();
  }

  // Save levels
  void setLevelsCompleted(int levelsCompleted) {
    if (levelsCompleted > this.levelsCompleted) {
      this.levelsCompleted = levelsCompleted;
      GetIt.I<ServiceLocalStorage>().setLevelsCompleted(levelsCompleted);
      notifyListeners();
    }
  }
}
