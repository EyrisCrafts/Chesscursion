import 'package:chesscursion_creator/config/service_locator.dart';
import 'package:chesscursion_creator/providers/prov_creator.dart';
import 'package:chesscursion_creator/providers/prov_game.dart';
import 'package:chesscursion_creator/providers/prov_prefs.dart';
import 'package:chesscursion_creator/providers/prov_user.dart';
import 'package:chesscursion_creator/screens/screen_game.dart';
import 'package:chesscursion_creator/screens/screen_main.dart';
import 'package:chesscursion_creator/services/service_local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';


//TODO
// Change structure of levels to include metadata of each level 
// Fix music bug
// Have a create new Level
// Setup Community

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await Hive.initFlutter();
  await GetIt.I<ServiceLocalStorage>().init();
  GetIt.I<ProvUser>().init();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ProvUser>(
            create: (context) => GetIt.I<ProvUser>(), 
          ),
          ChangeNotifierProvider<ProvPrefs>(
            create: (context) => GetIt.I<ProvPrefs>(),
          ),
          ChangeNotifierProvider<ProvGame>(
            create: (context) => GetIt.I<ProvGame>(),
          ),
          ChangeNotifierProvider<ProvCreator>(
            create: (context) => GetIt.I<ProvCreator>(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ChessCursion Creator',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const ScreenMain(),
          // home: const ScreenGame(),
        ));
  }
}
