import 'dart:developer';

import 'package:chesscursion_creator/providers/prov_creator.dart';
import 'package:chesscursion_creator/providers/prov_prefs.dart';
import 'package:chesscursion_creator/screens/widgets/board.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ScreenCreator extends StatefulWidget {
  const ScreenCreator({super.key});

  @override
  State<ScreenCreator> createState() => _ScreenCreatorState();
}

class _ScreenCreatorState extends State<ScreenCreator> {
  @override
  void initState() {
    super.initState();
    GetIt.I<ProvCreator>().setCreatorMode(isCreatorMode: true, isInGameMode: false, shouldNotify: false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (GetIt.I<ProvCreator>().isCreatorMode) {
          GetIt.I<ProvCreator>().setCreatorMode(isCreatorMode: false, isInGameMode: false);
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
