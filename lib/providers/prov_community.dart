import 'package:chesscursion_creator/config/enums.dart';
import 'package:chesscursion_creator/models/model_community_level.dart';
import 'package:chesscursion_creator/services/service_api_manager.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProvCommunity extends ChangeNotifier {
  List<ModelCommunityLevel> communityLevels;
  

  ProvCommunity({required this.communityLevels});

  Future<bool> loadCommunityLevels() async {
    if (communityLevels.isNotEmpty) {
      return true;
    }

    final levels = await GetIt.I<IServiceApiManager>().loadCommunityLevels();
    if (levels == null) {
      return false;
    }
    communityLevels = levels;

    notifyListeners();

    return true;
  }

  void upvote(String levelId) {
    try {
      communityLevels.firstWhere((element) => element.id == levelId).upVotes++;
    } catch (e) {
      return;
    }
    notifyListeners();
  }
}
