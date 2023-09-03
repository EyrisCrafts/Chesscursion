import 'dart:developer';

import 'package:chesscursion_creator/config/enums.dart';
import 'package:chesscursion_creator/config/extensions.dart';
import 'package:chesscursion_creator/providers/prov_creator.dart';
import 'package:chesscursion_creator/providers/prov_game.dart';
import 'package:chesscursion_creator/providers/prov_music.dart';
import 'package:chesscursion_creator/providers/prov_prefs.dart';
import 'package:chesscursion_creator/screens/widgets/board.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ScreenCreator extends StatefulWidget {
  const ScreenCreator({super.key});

  @override
  State<ScreenCreator> createState() => _ScreenCreatorState();
}

class _ScreenCreatorState extends State<ScreenCreator> with WidgetsBindingObserver {

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      GetIt.I<ProvMusic>().resumeMusic();
    } else {
      GetIt.I<ProvMusic>().pauseMusic();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    GetIt.I<ProvCreator>().setCreatorMode(enumGameMode: EnumGameMode.creatorCreate, shouldNotify: false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (GetIt.I<ProvGame>().enumGameMode.isCreaterMode()) {
          GetIt.I<ProvCreator>().setCreatorMode(enumGameMode: EnumGameMode.normal, shouldNotify: false);
          return true;
        }
        return true;
      },
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: Board(),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    GetIt.I<ProvPrefs>().setCellSize(context);
  }
}
