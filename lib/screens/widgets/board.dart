import 'package:chesscursion_creator/config/constants.dart';
import 'package:chesscursion_creator/providers/prov_creator.dart';
import 'package:chesscursion_creator/providers/prov_game.dart';
import 'package:chesscursion_creator/providers/prov_prefs.dart';
import 'package:chesscursion_creator/screens/widgets/Custom_icon_button.dart';
import 'package:chesscursion_creator/screens/widgets/cell.dart';
import 'package:chesscursion_creator/screens/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class Board extends StatelessWidget {
  const Board({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if (GetIt.I<ProvCreator>().isCreatorMode) {
      screenSize = Size(screenSize.width, screenSize.height - GetIt.I<ProvCreator>().creatorBoardSize);
    }
    return Container(
      alignment: Alignment.center,
      color: Constants.colorSecondary,
      child: Stack(
        children: [
          //Settings
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                height: screenSize.height,
                width: (screenSize.width - context.read<ProvPrefs>().cellSize * Constants.numHorizontalBoxes) - 10,
                color: Constants.colorSecondary,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    // const Text("Menu", style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: "Marko One")),
                    CustomButton(
                        inverseColors: true,
                        text: "Menu",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        width: 200,
                        fontSize: 15),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                        inverseColors: true,
                        text: "Levels",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        width: 200,
                        fontSize: 15),
                    const SizedBox(
                      height: 20,
                    ),
                    const Spacer(),
                    Consumer<ProvGame>(
                      builder: (context, value, child) {
                        return Text("Level\n${value.currentLevel + 1}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Marko One'));
                      },
                    ),

                    const Spacer(),

                    Row(
                      children: [
                        Expanded(
                          child: Selector<ProvGame, bool>(
                              selector: (p0, p1) => p1.isMusicAllowed,
                              builder: (context, isMusicAllowed, _) {
                                return CustomIconButton(
                                  onPressed: () {
                                    ProvGame prov = context.read<ProvGame>();
                                    // prov.switchMusic();
                                  },
                                  icon: isMusicAllowed ? FontAwesomeIcons.volumeHigh : FontAwesomeIcons.volumeXmark,
                                );
                              }),
                        ),
                        Expanded(
                          child: CustomIconButton(
                            onPressed: () {
                              ProvGame prov = context.read<ProvGame>();
                              prov.setLevel(prov.currentLevel);
                            },
                            icon: FontAwesomeIcons.rotate,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (int ind = 0; ind < Constants.numVerticalBoxes; ind++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        for (int index = 0; index < Constants.numHorizontalBoxes; index++)
                          Consumer<ProvGame>(builder: (context, game, _) {
                            return Cell(
                              key: context.read<ProvGame>().boardKeys[ind][index],
                              index: index + (ind * Constants.numHorizontalBoxes),
                              cellContent: game.board[ind][index],
                              onTap: () {
                                context.read<ProvGame>().onCellTapped(index, ind, context);
                              },
                            );
                          })
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
