import 'dart:developer';

import 'package:chesscursion_creator/config/constants.dart';
import 'package:chesscursion_creator/config/local_data.dart';
import 'package:chesscursion_creator/providers/prov_game.dart';
import 'package:chesscursion_creator/screens/screen_game.dart';
import 'package:chesscursion_creator/screens/widgets/custom_back.dart';
import 'package:chesscursion_creator/screens/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

class ScreenLevels extends StatefulWidget {
  const ScreenLevels({super.key});

  @override
  State<ScreenLevels> createState() => _ScreenLevelsState();
}

class _ScreenLevelsState extends State<ScreenLevels> {
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
                child: CustomScrollView(
                            slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomBack(),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Levels", style: TextStyle(fontSize: 18, color: Constants.colorSecondary, fontFamily: "Marko One")),
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
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20.0),
                  
                  sliver: SliverGrid.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        mainAxisExtent: 80,
                        maxCrossAxisExtent: 80,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: LocalData.levels.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            GetIt.I<ProvGame>().setLevel(index);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ScreenGame()));
                          },
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Constants.colorSecondary, boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3), // changes position of shadow
                              )
                            ]),
                            alignment: Alignment.center,
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(color: Colors.white, fontSize: 30, fontFamily: "Marko One"),
                            ),
                          ),
                        );
                      }),
                )
                            ],
                          )),
            // Positioned.fill(
            //     child: Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(20.0),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           const Row(
            //             mainAxisSize: MainAxisSize.min,
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               CustomBack(),
            //               SizedBox(
            //                 width: 10,
            //               ),
            //               Text("Levels", style: TextStyle(fontSize: 18, color: Constants.colorSecondary, fontFamily: "Marko One")),
            //             ],
            //           ),
            //           CustomButton(
            //               fontSize: 15,
            //               width: 200,
            //               text: "Create your own",
            //               onPressed: () {
            //                 // TODO Send to creator
            //               })
            //         ],
            //       ),
            //     ),
            //     GridView.builder(
            //       shrinkWrap: true,
            //       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            //         mainAxisExtent: 100,
            //         maxCrossAxisExtent: 100,
            //         crossAxisSpacing: 10,
            //         mainAxisSpacing: 10,
            //       ),
            //       padding: const EdgeInsets.all(20),
            //       itemBuilder: (context, index) {
            //         return GestureDetector(
            //           onTap: () {
            //             GetIt.I<ProvGame>().setLevel(index);
            //             Navigator.push(context, MaterialPageRoute(builder: (context) => const ScreenGame()));
            //           },
            //           child: Container(
            //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Constants.colorSecondary, boxShadow: [
            //               BoxShadow(
            //                 color: Colors.black.withOpacity(0.3),
            //                 spreadRadius: 1,
            //                 blurRadius: 5,
            //                 offset: const Offset(0, 3), // changes position of shadow
            //               )
            //             ]),
            //             alignment: Alignment.center,
            //             child: Text(
            //               "${index + 1}",
            //               style: const TextStyle(color: Colors.white, fontSize: 30, fontFamily: "Marko One"),
            //             ),
            //           ),
            //         );
            //       },
            //       itemCount: LocalData.levels.length,
            //     )
            //   ],
            // )),
         
          ],
        ));
  }
}