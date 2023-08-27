import 'package:chesscursion_creator/screens/screen_community.dart';
import 'package:chesscursion_creator/screens/screen_levels.dart';
import 'package:chesscursion_creator/screens/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class ScreenMain extends StatefulWidget {
  const ScreenMain({super.key});

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // GetIt.I<ProvGame>().switchMusic();
    });
  }

  @override
  void dispose() {
    // GetIt.I<ProvGame>().stopMusic();
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
