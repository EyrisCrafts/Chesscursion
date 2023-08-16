import 'package:chesscursion_creator/config/service_locator.dart';
import 'package:chesscursion_creator/providers/prov_creator.dart';
import 'package:chesscursion_creator/providers/prov_game.dart';
import 'package:chesscursion_creator/providers/prov_prefs.dart';
import 'package:chesscursion_creator/screens/screen_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';


//TODO
// If you land on top after gravity, kill auto
// Fix Step usage
// Add key and lock
// Add doors


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
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
          home: const ScreenGame(),
        ));
  }
}
