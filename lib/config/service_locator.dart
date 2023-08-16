import 'package:chesscursion_creator/providers/prov_creator.dart';
import 'package:chesscursion_creator/providers/prov_game.dart';
import 'package:chesscursion_creator/providers/prov_prefs.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<ProvGame>(ProvGame());
  getIt.registerSingleton<ProvPrefs>(ProvPrefs());
  getIt.registerSingleton<ProvCreator>(ProvCreator());
}
