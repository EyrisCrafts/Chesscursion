import 'package:chesscursion_creator/config/constants.dart';
import 'package:chesscursion_creator/config/enums.dart';
import 'package:chesscursion_creator/config/extensions.dart';
import 'package:chesscursion_creator/custom_toast.dart';
import 'package:chesscursion_creator/providers/prov_creator.dart';
import 'package:chesscursion_creator/providers/prov_game.dart';
import 'package:chesscursion_creator/providers/prov_prefs.dart';
import 'package:chesscursion_creator/screens/widgets/Custom_icon_button.dart';
import 'package:chesscursion_creator/screens/widgets/cell.dart';
import 'package:chesscursion_creator/screens/widgets/creator_icon.dart';
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
    // if (GetIt.I<ProvCreator>().isCreatorMode) {
    //   screenSize = Size(screenSize.width, screenSize.height - GetIt.I<ProvCreator>().creatorBoardSize);
    // }
    final isCreatorMode = context.read<ProvCreator>().isCreatorMode;
    double menuSize = (screenSize.width - context.read<ProvPrefs>().cellSize * Constants.numHorizontalBoxes) - 10;
    Alignment boardAlignment = Alignment.centerRight;
    if (isCreatorMode) {
      menuSize = (screenSize.width - context.read<ProvPrefs>().cellSize * Constants.numHorizontalBoxes) / 2;
      boardAlignment = Alignment.center;
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
                width: menuSize,
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
                          Navigator.maybePop(context);
                        },
                        width: 200,
                        fontSize: 15),
                    const SizedBox(
                      height: 20,
                    ),
                    if (!isCreatorMode)
                      CustomButton(
                          inverseColors: true,
                          text: "Levels",
                          onPressed: () {
                            Navigator.maybePop(context);
                          },
                          width: 200,
                          fontSize: 15),
                    const SizedBox(
                      height: 20,
                    ),
                    const Spacer(),
                    if (!isCreatorMode)
                      Consumer<ProvGame>(
                        builder: (context, value, child) {
                          return Text("Level\n${value.currentLevel + 1}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Marko One'));
                        },
                      ),

                    const Spacer(),
                    if (!isCreatorMode)
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
                    if (isCreatorMode)
                      Consumer<ProvCreator>(builder: (context, provCreator, _) {
                        return CustomIconButton(
                            isSelected: provCreator.isGameInCreatorMode,
                            onPressed: () {
                              // Must have at least one black king
                              if (!GetIt.I<ProvGame>().isPieceOnBoard(EnumBoardPiece.blackKing)) {
                                // Toast if no white king
                                CustomToast.showToast("Must have at least one black king", leadingIcon: const Icon(Icons.warning, color: Constants.colorSecondary));
                              } else {
                                GetIt.I<ProvCreator>().setCreatorMode(isCreatorMode: true, isGameInCreatorMode: !provCreator.isGameInCreatorMode);
                              }
                            },
                            icon: FontAwesomeIcons.play);
                      }),
                    if (isCreatorMode)
                      const SizedBox(
                        height: 20,
                      ),

                    CustomIconButton(
                        onPressed: () {
                         GetIt.I<ProvCreator>().restartBoard();
                        },
                        icon: FontAwesomeIcons.arrowsRotate),

                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )),
          ),

          // Board
          Align(
            alignment: boardAlignment,
            child: Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (int ind = 0; ind < Constants.numVerticalBoxes; ind++)
                    Row(
                      mainAxisAlignment: isCreatorMode ? MainAxisAlignment.center : MainAxisAlignment.end,
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

          // List of Pieces that can be put on board
          if (isCreatorMode)
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                  height: double.maxFinite,
                  width: menuSize,
                  color: Colors.pink.withOpacity(0.2),
                  child: ListView(padding: const EdgeInsets.symmetric(vertical: 20), scrollDirection: Axis.vertical, children: [
                    ...List.generate(
                        EnumBoardPiece.values.getMaterialPieces().length,
                        (index) => Consumer<ProvCreator>(builder: (context, provCreator, _) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: CreatorIcon(
                                  piece: EnumBoardPiece.values.getMaterialPieces()[index],
                                  isSelected: provCreator.selectedPiece == EnumBoardPiece.values.getMaterialPieces()[index],
                                  onTap: () {
                                    GetIt.I<ProvCreator>().selectPiece(EnumBoardPiece.values.getMaterialPieces()[index]);
                                  },
                                ),
                              );
                              // return Cell(
                              //   key: ValueKey(index),
                              //   index: provCreator.selectedPiece == EnumBoardPiece.values[index] ? 1 : 0,
                              //   cellContent: [EnumBoardPiece.values[index]],
                              //   onTap: () {
                              //     // Make it selected
                              //     GetIt.I<ProvCreator>().selectPiece(EnumBoardPiece.values[index]);
                              //   },
                              // );
                            })),
                    if (GetIt.I<ProvCreator>().isDeveloper)
                      IconButton.outlined(
                          onPressed: () {
                            // Save board to disk? to clipboard?
                            GetIt.I<ProvCreator>().saveBoard();
                          },
                          icon: const Icon(Icons.save_alt)),
                  ])),
            )
        ],
      ),
    );
  }
}
