
import 'package:chesscursion_creator/config/constants.dart';
import 'package:chesscursion_creator/screens/widgets/custom_back.dart';
import 'package:chesscursion_creator/screens/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScreenCommunity extends StatefulWidget {
  const ScreenCommunity({super.key});

  @override
  State<ScreenCommunity> createState() => _ScreenCommunityState();
}

class _ScreenCommunityState extends State<ScreenCommunity> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xffE3F6E3),
        body: Stack(
          children: [
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
            Positioned.fill(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomBack(),
                          SizedBox(width: 10,),
                          Text("Community", style: TextStyle(fontSize: 18, color: Constants.colorSecondary, fontFamily: "Marko One")),
                        ],
                      ),
                      CustomButton(
                          fontSize: 15,
                          width: 200,
                          text: "Create your own",
                          onPressed: () {
                            // TODO Send to creator
                          })
                    ],
                  ),
                ),
              ],
            )),
          ],
        ));
  }
}