import 'dart:developer';

import 'package:chesscursion_creator/config/constants.dart';
import 'package:chesscursion_creator/config/enums.dart';
import 'package:chesscursion_creator/config/extensions.dart';
import 'package:chesscursion_creator/config/utils.dart';
import 'package:chesscursion_creator/custom_toast.dart';
import 'package:chesscursion_creator/models/model_community_level.dart';
import 'package:chesscursion_creator/overlays/overlay_share_level.dart';
import 'package:chesscursion_creator/providers/prov_community.dart';
import 'package:chesscursion_creator/providers/prov_creator.dart';
import 'package:chesscursion_creator/providers/prov_game.dart';
import 'package:chesscursion_creator/providers/prov_prefs.dart';
import 'package:chesscursion_creator/providers/prov_user.dart';
import 'package:chesscursion_creator/screens/widgets/Custom_icon_button.dart';
import 'package:chesscursion_creator/screens/widgets/cell.dart';
import 'package:chesscursion_creator/screens/widgets/creator_icon.dart';
import 'package:chesscursion_creator/screens/widgets/custom_button.dart';
import 'package:chesscursion_creator/services/service_api_manager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class Board extends StatelessWidget {
  const Board({Key? key, this.communityLevel}) : super(key: key);
  final ModelCommunityLevel? communityLevel;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final enumGameMode = context.read<ProvGame>().enumGameMode;
    double menuSize = (screenSize.width - context.read<ProvPrefs>().cellSize * Constants.numHorizontalBoxes) - 10;
    Alignment boardAlignment = Alignment.centerRight;
    if (enumGameMode.isCreaterMode()) {
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
                        text: "Back",
                        onPressed: () {
                          Navigator.maybePop(context);
                        },
                        width: 200,
                        fontSize: 15),
                    const SizedBox(
                      height: 20,
                    ),
                    if (enumGameMode.isCreaterMode())
                      CustomButton(
                          inverseColors: true,
                          text: "Share",
                          onPressed: () async {
                            if (!GetIt.I<ProvGame>().isPieceOnBoard(EnumBoardPiece.blackKing)) {
                              // Toast if no white king
                              CustomToast.showToast("Must have at least one black king", leadingIcon: const Icon(Icons.warning, color: Constants.colorSecondary));
                              return;
                            }
                            // Confirm Share level
                            final response = await showDialog(context: context, builder: (context) => const OverlayShareLevel());
                            if (response is String) {
                              if (!GetIt.I<IServiceApiManager>().isLoggedIn()) {
                                final isSuccess = await GetIt.I<IServiceApiManager>().login();
                                if (!isSuccess) {
                                  CustomToast.showToast("Login failed", leadingIcon: const Icon(Icons.warning, color: Constants.colorSecondary));
                                  return;
                                }
                              }
                              await Future.delayed(const Duration(seconds: 1), () {});
                              final generatedId = GetIt.I<IServiceApiManager>().generateId();
                              final now = DateTime.now();
                              final userId = GetIt.I<IServiceApiManager>().getUserId();

                              List<List<List<int>>> board = [];

                              // If in play mode, Take board from tmp
                              if (GetIt.I<ProvGame>().enumGameMode == EnumGameMode.creatorPlay) {
                                board = Utils.convertBoardToRaw(GetIt.I<ProvCreator>().tmpBoard);
                              } else {
                                // Otherwise take it from the game
                                board = Utils.convertBoardToRaw(GetIt.I<ProvGame>().board);
                              }
                              final resp = await GetIt.I<IServiceApiManager>().writeCommunityLevel(
                                  ModelCommunityLevel(documentId: "", id: generatedId, title: response, createdById: userId, createdByName: "", createdOn: now, board: board, upVotes: 0));
                              log("response $resp");
                            }
                          },
                          width: 200,
                          fontSize: 15),
                    if (communityLevel != null)
                      Consumer<ProvCommunity>(builder: (context, provCommunity, _) {
                        int voteCount = 0;
                        try {
                          voteCount = provCommunity.communityLevels.firstWhere((element) => element.id == communityLevel!.id).upVotes;
                        } catch (e) {
                          voteCount = 0;
                        }
                        return CustomButton(
                            inverseColors: true,
                            text: "$voteCount Upvote",
                            onPressed: () async {
                              // login check
                              if (!GetIt.I<IServiceApiManager>().isLoggedIn()) {
                                final isSuccess = await GetIt.I<IServiceApiManager>().login();
                                if (!isSuccess) {
                                  CustomToast.showToast("Login failed", leadingIcon: const Icon(Icons.warning, color: Constants.colorSecondary));
                                  return;
                                }
                              }
                              final bool isSuccess = await GetIt.I<IServiceApiManager>().upvoteCommunityLevel(communityLevel!.id, communityLevel!.documentId);
                              if (isSuccess) {
                                CustomToast.showToast("Upvoted", leadingIcon: const Icon(Icons.thumb_up, color: Constants.colorSecondary));
                                GetIt.I<ProvUser>().upvote(communityLevel!.id);
                                GetIt.I<ProvCommunity>().upvote(communityLevel!.id);
                              } else {
                                CustomToast.showToast("Already upvoted", leadingIcon: const Icon(Icons.thumb_up, color: Constants.colorSecondary));
                              }
                            },
                            width: 200,
                            fontSize: 15);
                      }),
                    const Spacer(),
                    if (!enumGameMode.isCreaterMode() && communityLevel == null)
                      Consumer<ProvGame>(
                        builder: (context, value, child) {
                          return Text("Level\n${value.currentLevel + 1}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Marko One'));
                        },
                      ),
                    if (communityLevel != null) Text(communityLevel!.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'Marko One')),

                    const Spacer(),
                    if (!enumGameMode.isCreaterMode())
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
                    if (enumGameMode.isCreaterMode())
                      Consumer<ProvGame>(builder: (context, provGame, _) {
                        return CustomIconButton(
                            isSelected: provGame.enumGameMode == EnumGameMode.creatorPlay,
                            onPressed: () {
                              final gameMode = GetIt.I<ProvGame>().enumGameMode;
                              // If in creator play mode, restart board
                              if (gameMode == EnumGameMode.creatorPlay) {
                                GetIt.I<ProvCreator>().setCreatorMode(enumGameMode: EnumGameMode.creatorCreate);
                                GetIt.I<ProvCreator>().resetBoard();
                                return;
                              }
                              // Must have at least one black king
                              if (!GetIt.I<ProvGame>().isPieceOnBoard(EnumBoardPiece.blackKing)) {
                                // Toast if no white king
                                CustomToast.showToast("Must have at least one black king", leadingIcon: const Icon(Icons.warning, color: Constants.colorSecondary));
                              } else {
                                GetIt.I<ProvCreator>().setCreatorMode(
                                    enumGameMode: gameMode == EnumGameMode.creatorCreate ? EnumGameMode.creatorPlay : EnumGameMode.creatorCreate, shouldNotify: true);
                              }
                            },
                            icon: FontAwesomeIcons.play);
                      }),
                    if (enumGameMode.isCreaterMode())
                      const SizedBox(
                        height: 20,
                      ),
                    if (enumGameMode.isCreaterMode())
                      CustomIconButton(
                          onPressed: () {
                            if (GetIt.I<ProvGame>().enumGameMode == EnumGameMode.creatorPlay) {
                              GetIt.I<ProvCreator>().setCreatorMode(enumGameMode: EnumGameMode.creatorCreate);
                              GetIt.I<ProvCreator>().resetBoard();
                              return;
                            }
                            GetIt.I<ProvCreator>().restartBoard();
                          },
                          icon: FontAwesomeIcons.arrowsRotate),
                    // if (GetIt.I<ProvGame>().isDeveloperMode)
                      IconButton.outlined(
                          onPressed: () {
                            // Save board to disk? to clipboard?
                            GetIt.I<ProvCreator>().saveBoard();
                          },
                          icon: const Icon(Icons.save_alt)),
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
                      mainAxisAlignment: enumGameMode.isCreaterMode() ? MainAxisAlignment.center : MainAxisAlignment.end,
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
          if (enumGameMode.isCreaterMode())
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
                            })),
                    
                  ])),
            )
        ],
      ),
    );
  }
}
