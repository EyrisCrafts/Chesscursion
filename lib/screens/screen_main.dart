import 'dart:developer';

import 'package:chesscursion_creator/providers/prov_music.dart';
import 'package:chesscursion_creator/screens/screen_community.dart';
import 'package:chesscursion_creator/screens/screen_levels.dart';
import 'package:chesscursion_creator/screens/widgets/Custom_icon_button.dart';
import 'package:chesscursion_creator/screens/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ScreenMain extends StatefulWidget {
  const ScreenMain({super.key});

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      GetIt.I<ProvMusic>().playBackgroundMusic();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      GetIt.I<ProvMusic>().resumeMusic();
    } else {
      GetIt.I<ProvMusic>().pauseMusic();
    }
  }

  @override
  void dispose() {
    log("stopping music");
    GetIt.I<ProvMusic>().disposeMusic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffE3F6E3),
      body: Stack(children: [
        SizedBox(
          height: size.height,
          width: size.width,
          child: Opacity(
              opacity: 0.7,
              child: SvgPicture.asset(
                "assets/svgs/background_h.svg",
                fit: BoxFit.cover,
                alignment: Alignment.center,
              )),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Selector<ProvMusic, bool>(
              selector: (p0, p1) => p1.isMusicOn,
              builder: (context, isMusicAllowed, _) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    // height: 50,
                    // width: 50,
                    child: CustomIconButton(
                      defaultSize: false,
                      onPressed: () {
                        GetIt.I<ProvMusic>().toggleMusic();
                      },
                      icon: isMusicAllowed ? FontAwesomeIcons.volumeHigh : FontAwesomeIcons.volumeXmark,
                    ),
                  ),
                );
              }),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: "Play",
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ScreenLevels()));
                },
              ),
              const SizedBox(
                height: 30,
              ),
              CustomButton(
                fontSize: 18,
                width: 170,
                text: "Community",
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ScreenCommunity()));
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
