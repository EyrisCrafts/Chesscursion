import 'dart:developer';

import 'package:chesscursion_creator/config/constants.dart';
import 'package:chesscursion_creator/config/enums.dart';
import 'package:chesscursion_creator/config/extensions.dart';
import 'package:chesscursion_creator/config/utils.dart';
import 'package:chesscursion_creator/custom_toast.dart';
import 'package:chesscursion_creator/models/model_community_level.dart';
import 'package:chesscursion_creator/providers/prov_community.dart';
import 'package:chesscursion_creator/providers/prov_creator.dart';
import 'package:chesscursion_creator/providers/prov_game.dart';
import 'package:chesscursion_creator/screens/screen_creator.dart';
import 'package:chesscursion_creator/screens/screen_game.dart';
import 'package:chesscursion_creator/screens/widgets/custom_back.dart';
import 'package:chesscursion_creator/screens/widgets/custom_button.dart';
import 'package:chesscursion_creator/screens/widgets/miniboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScreenCommunity extends StatefulWidget {
  const ScreenCommunity({super.key});

  @override
  State<ScreenCommunity> createState() => _ScreenCommunityState();
}

class _ScreenCommunityState extends State<ScreenCommunity> {
  @override
  void initState() {
    GetIt.I<ProvCommunity>().loadCommunityLevels().then((value) {
      if (!value) {
        CustomToast.showToast("Error Loading community");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provCommunity = context.watch<ProvCommunity>();
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
            Positioned.fill(child: LayoutBuilder(builder: (context, constraints) {
              return CustomScrollView(
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
                              Text("Community", style: TextStyle(fontSize: 18, color: Constants.colorSecondary, fontFamily: "Marko One")),
                            ],
                          ),
                          CustomButton(
                              fontSize: 15,
                              width: 200,
                              text: "Create your own",
                              onPressed: () {
                                GetIt.I<ProvCreator>().restartBoard();
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const ScreenCreator()));
                              })
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                      padding: const EdgeInsets.all(20.0),
                      sliver: Consumer<ProvCommunity>(builder: (context, provCommunity, _) {
                        return SliverGrid(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            return CommunityLevel(
                              data: provCommunity.communityLevels[index],
                              key: ValueKey(provCommunity.communityLevels[index].id),
                              onTap: () {
                                GetIt.I<ProvGame>().updateGameMode(EnumGameMode.community, shouldNotify: false);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ScreenGame(
                                              communityLevel: provCommunity.communityLevels[index],
                                            )));
                              },
                            );
                          }, childCount: provCommunity.communityLevels.length),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _calculateColumns(constraints.maxWidth - 40), crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1),
                        );
                      }))
                ],
              );
            })),
          ],
        ));
  }

  int _calculateColumns(double maxWidth) {
    const double itemWidth = 160;
    const double spacing = 10;
    // Using ~/ to get an integer division
    int columns = (maxWidth ~/ (itemWidth + spacing));
    return columns;
  }
}

class CommunityLevel extends StatelessWidget {
  const CommunityLevel({super.key, required this.data, required this.onTap});
  final ModelCommunityLevel data;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Container(
            // color: Colors.pink,
            color: Colors.transparent,
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.title.toString(), maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: Constants.colorSecondary, fontFamily: "Marko One")),
                Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.arrowUp,
                      size: 17,
                      color: Constants.colorPrimary,
                    ),
                    Text(data.upVotes.toString(), style: const TextStyle(fontSize: 18, color: Constants.colorPrimary, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Text(data.createdOn.timeSince(), style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: "Marko One")),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MiniBoard(
                      board: Utils.convertBoard(data.board),
                      onTap: onTap,
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
