import 'package:chesscursion_creator/services/service_api_manager.dart';
import 'package:chesscursion_creator/services/service_local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProvUser extends ChangeNotifier {
  int levelsCompleted = 0;

  List<String>? levelsUpvoted;

  void init() {
    levelsCompleted = GetIt.I<ServiceLocalStorage>().getLevelsCompleted();
  }

  Future<List<String>> getLevelsUpvoted() async {
    levelsUpvoted ??= await GetIt.I<IServiceApiManager>().getUserLevelsUpvoted();
    return levelsUpvoted ?? [];
  }

  void upvote(String levelId) {
    levelsUpvoted ??= [];
    levelsUpvoted!.add(levelId);
    notifyListeners();
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
