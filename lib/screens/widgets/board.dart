import 'package:chesscursion_creator/config/constants.dart';
import 'package:chesscursion_creator/config/local_data.dart';
import 'package:chesscursion_creator/providers/prov_creator.dart';
import 'package:chesscursion_creator/providers/prov_game.dart';
import 'package:chesscursion_creator/providers/prov_prefs.dart';
import 'package:chesscursion_creator/screens/widgets/cell.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
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
      color: const Color.fromARGB(255, 105, 75, 31),
      child: Stack(
        children: [
          //Settings
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
                height: screenSize.height,
                width: (screenSize.width - context.read<ProvPrefs>().cellSize * Constants.numHorizontalBoxes) / 2,
                color: const Color.fromARGB(255, 141, 102, 42),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text("Menu", ),
                    // Text("Menu", style: GoogleFonts.permanentMarker(fontSize: 20, color: Colors.white)),
                    const SizedBox(
                      height: 20,
                    ),
                    IconButton(
                        onPressed: () {
                          ProvGame prov = context.read<ProvGame>();
                          prov.setLevel(prov.currentLevel);
                        },
                        icon: const Icon(FontAwesomeIcons.rotate, color: Colors.white, size: 30)),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          ProvGame prov = context.read<ProvGame>();
                          prov.switchMusic();
                        },
                        icon: Selector<ProvGame, bool>(
                            selector: (p0, p1) => p1.isMusicAllowed,
                            builder: (context, isMusicAllowed, _) {
                              return Icon(isMusicAllowed ? FontAwesomeIcons.volumeHigh : FontAwesomeIcons.volumeXmark, color: Colors.white, size: 30);
                            })),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )),
          ),
          //Levels
          Align(
            child: Container(
              height: screenSize.height,
              width: (screenSize.width - context.read<ProvPrefs>().cellSize * Constants.numHorizontalBoxes) / 2,
              color: const Color.fromARGB(255, 141, 102, 42),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text("Levels !", ),
                    // Text("Levels !", style: GoogleFonts.permanentMarker(fontSize: 20, color: Colors.white)),
                    const SizedBox(
                      height: 10,
                    ),
                    for (int i = 0; i < LocalData.levels.length; i++)
                      IconButton(
                          onPressed: () {
                            context.read<ProvGame>().setLevel(i);
                          },
                          icon: Selector<ProvGame, int>(
                              selector: (p0, p1) => p1.currentLevel,
                              builder: (context, currentLevel, _) {
                                return Container(
                                    height: 30,
                                    width: 30,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: currentLevel == i ? Colors.blue : Colors.white),
                                    child: Text("${i + 1}", style: TextStyle(fontSize: 20, color: currentLevel == i ? Colors.white : Colors.black)));
                                    // child: Text("${i + 1}", style: GoogleFonts.permanentMarker(fontSize: 20, color: currentLevel == i ? Colors.white : Colors.black)));
                              }))
                  ],
                ),
              ),
            ),
            alignment: Alignment.centerRight,
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int ind = 0; ind < Constants.numVerticalBoxes; ind++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
        ],
      ),
    );
  }
}
