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

  bool isCreatorMode = false;
  EnumBoardPiece? selectedPiece;
  int creatorBoardSize = 100;
  List<List<List<EnumBoardPiece>>> translatedMainBoard = [];

  void selectPiece(EnumBoardPiece piece) {
    selectedPiece = piece;
    notifyListeners();
  }

  void saveBoard() {
    List<List<List<int>>> raw = Utils.convertBoardToRaw(translatedMainBoard);
    log(raw.toString());
  }

  void restartBoard() {
    translatedMainBoard = Utils.convertBoard(emptyBoard.map((element) => List<List<int>>.from(element)).toList());
    // Set to that level in the game
    GetIt.I<ProvGame>().setBoard(translatedMainBoard);
  }

  List<List<List<int>>> emptyBoard = [
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
  ];

  List<List<List<int>>> mainBoard = [
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
    [[0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0], [0]],
  ];
}
