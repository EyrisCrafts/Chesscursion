import 'package:chesscursion_creator/providers/prov_creator.dart';
import 'package:chesscursion_creator/providers/prov_game.dart';
import 'package:chesscursion_creator/providers/prov_prefs.dart';
import 'package:chesscursion_creator/providers/prov_user.dart';
import 'package:chesscursion_creator/services/service_local_storage.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<ProvUser>(ProvUser());
  getIt.registerSingleton<ProvGame>(ProvGame());
  getIt.registerSingleton<ProvPrefs>(ProvPrefs());
  getIt.registerSingleton<ProvCreator>(ProvCreator());
  getIt.registerSingleton<ServiceLocalStorage>(ServiceLocalStorage());
}
