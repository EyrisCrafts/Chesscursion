import 'package:chesscursion_creator/config/service_locator.dart';
import 'package:chesscursion_creator/firebase_options.dart';
import 'package:chesscursion_creator/providers/prov_community.dart';
import 'package:chesscursion_creator/providers/prov_creator.dart';
import 'package:chesscursion_creator/providers/prov_game.dart';
import 'package:chesscursion_creator/providers/prov_music.dart';
import 'package:chesscursion_creator/providers/prov_prefs.dart';
import 'package:chesscursion_creator/providers/prov_user.dart';
import 'package:chesscursion_creator/screens/screen_game.dart';
import 'package:chesscursion_creator/screens/screen_main.dart';
import 'package:chesscursion_creator/services/service_local_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

//TODO
// Fix music bug
// Take pictures of app
// Creator not working sometime
// level 19, when you take key, everything floats. Do a gravity check
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await Hive.initFlutter();
  await GetIt.I<ServiceLocalStorage>().init();
  GetIt.I<ProvUser>().init();
  Wakelock.enable();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ProvUser>(
            create: (context) => GetIt.I<ProvUser>(),
          ),
          ChangeNotifierProvider<ProvPrefs>(
            create: (context) => GetIt.I<ProvPrefs>(),
          ),
          ChangeNotifierProvider<ProvCommunity>(
            create: (context) => GetIt.I<ProvCommunity>(),
          ),
          ChangeNotifierProvider<ProvGame>(
            create: (context) => GetIt.I<ProvGame>(),
          ),
          ChangeNotifierProvider<ProvCreator>(
            create: (context) => GetIt.I<ProvCreator>(),
          ),
          ChangeNotifierProvider<ProvMusic>(
            create: (context) => GetIt.I<ProvMusic>(),
          ),
        ],
        child: MaterialApp(
          builder: (context, child) {
            return OKToast(child: child!);
          },
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
