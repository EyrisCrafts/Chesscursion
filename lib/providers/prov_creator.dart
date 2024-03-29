import 'dart:developer';

import 'package:chesscursion_creator/config/enums.dart';
import 'package:chesscursion_creator/config/utils.dart';
import 'package:chesscursion_creator/providers/prov_game.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProvCreator extends ChangeNotifier {
  ProvCreator() {
    translatedMainBoard = Utils.convertBoard(mainBoard);
  }

  EnumBoardPiece? selectedPiece;
  int creatorBoardSize = 100;
  List<List<List<EnumBoardPiece>>> translatedMainBoard = [];
  List<List<List<EnumBoardPiece>>> tmpBoard = [];

  void setCreatorMode({EnumGameMode enumGameMode = EnumGameMode.normal, bool shouldNotify = true}) {
    log("setCreatorMode: $shouldNotify");
    GetIt.I<ProvGame>().updateGameMode(enumGameMode, shouldNotify: shouldNotify);
    if (enumGameMode == EnumGameMode.creatorPlay) {
      tmpBoard = [];

      for (int i = 0; i < translatedMainBoard.length; i++) {
        if (tmpBoard.length <= i) {
          tmpBoard.add([]);
        }
        for (int j = 0; j < translatedMainBoard[i].length; j++) {
          if (tmpBoard[i].length <= j) {
            tmpBoard[i].add([]);
          }
          for (int k = 0; k < translatedMainBoard[i][j].length; k++) {
            if (tmpBoard[i][j].length <= k) {
              tmpBoard[i][j].add(EnumBoardPiece.blank);
            }
            tmpBoard[i][j][k] = translatedMainBoard[i][j][k];
          }
        }
      }
    }
    if (shouldNotify) {
      notifyListeners();
    }
  }

  void selectPiece(EnumBoardPiece piece) {
    selectedPiece = piece;
    notifyListeners();
  }

  void saveBoard() {
    List<List<List<int>>> raw = Utils.convertBoardToRaw(translatedMainBoard);

    log(raw.toString());
  }

  void restartBoard({bool shouldNotify = true}) {
    translatedMainBoard = Utils.convertBoard(emptyBoard.map((element) => List<List<int>>.from(element)).toList());
    // Set to that level in the game
    GetIt.I<ProvGame>().setBoard(translatedMainBoard, shouldNotify: shouldNotify);
  }

  void resetBoard() {
    translatedMainBoard = tmpBoard;
    GetIt.I<ProvGame>().setBoard(translatedMainBoard);
  }

  List<List<List<int>>> emptyBoard = [
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
  ];

  List<List<List<int>>> mainBoard = [
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
    [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0]
    ],
  ];
}
