import 'package:audioplayers/audioplayers.dart';
import 'package:chesscursion_creator/config/constants.dart';
import 'package:chesscursion_creator/config/enums.dart';
import 'package:chesscursion_creator/config/extensions.dart';
import 'package:chesscursion_creator/config/local_data.dart';
import 'package:chesscursion_creator/config/utils.dart';
import 'package:chesscursion_creator/models/model_position.dart';
import 'package:chesscursion_creator/models/selected_piece.dart';
import 'package:chesscursion_creator/overlays/overlay_piece.dart';
import 'package:chesscursion_creator/overlays/overlay_won.dart';
import 'package:chesscursion_creator/providers/prov_creator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProvGame extends ChangeNotifier {
  List<List<EnumBoardPiece>> board = [];
  late SelectedPiece selectedPiece;
  List<List<GlobalKey>> boardKeys = [];
  late int currentLevel;
  late AudioPlayer audioBackground;
  late AudioPlayer audioMove;
  late AudioCache audioCacheBackground;
  late AudioCache audioCacheMove;
  bool isMusicAllowed = true;

  void onCellTapped(int x, int y, BuildContext context) {
    if (GetIt.I<ProvCreator>().isCreatorMode) {
      board[y][x] = GetIt.I<ProvCreator>().selectedPiece!;
      notifyListeners();
      return;
    }
    if (isMoveAnimationInProgress) return;
    if (selectedPiece.isSelected) {
      if (Utils.getPossibleMove(board, selectedPiece.position!).contains(ModelPosition(x, y))) {
        ModelPosition finalDestination = ModelPosition(x, y);
        if (board[y][x].isStep()) {
          finalDestination = ModelPosition(x, y - 1);
        }

        // if destination is not a black piece, play move sound
        if (!board[finalDestination.y][finalDestination.x].isPieceBlack()) {
          audioPlayMove();
        } else {
          audioPlayMove(isKill: true);
        }
        // If new place has a step, move on top of it
        board[selectedPiece.position!.y][selectedPiece.position!.x] = EnumBoardPiece.blank;
        board[finalDestination.y][finalDestination.x] = selectedPiece.selectedPiece!;

        notifyListeners();

        //Win check
        winCheckCondition(context);

        //Gravity Check !
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          for (int my = 0; my < 10; my++) {
            for (int mx = 0; mx < Constants.numHorizontalBoxes; mx++) {
              if (!board[my][mx].isEmpty() && !board[my][mx].isBlock() && !board[my][mx].isStep()) {
                gravitycheck(context, ModelPosition(mx, my));
              }
            }
          }
        });
      }
      selectedPiece.isSelected = false;
      removeSuggestions();
    } else {
      if (board[y][x].isPieceWhite()) {
        selectedPiece.isSelected = true;
        selectedPiece.selectedPiece = board[y][x];
        selectedPiece.position = ModelPosition(x, y);

        updateSuggestions();
      }
    }
  }

  void setLevel(int level) {
    if (level == LocalData.levels.length) level = 0;
    currentLevel = level;
    board = convertBoard(LocalData.levels[level].map((element) => List<int>.from(element)).toList());
    selectedPiece.isSelected = false;
    notifyListeners();
  }

  void setBoard(List<List<EnumBoardPiece>> newBoard) {
    board = newBoard;
    selectedPiece.isSelected = false;
    notifyListeners();
  }

  bool blackExists() {
    for (int my = 0; my < 10; my++) {
      for (int mx = 0; mx < Constants.numHorizontalBoxes; mx++) {
        if (board[my][mx].isPieceBlack()) {
          return true;
        }
      }
    }
    return false;
  }

  void winCheckCondition(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (!blackExists()) {
      OverlayEntry entry = OverlayEntry(builder: (context) => const OverlayWon());
      Overlay.of(context).insert(entry);
      Future.delayed(const Duration(milliseconds: 3000), () {
        entry.remove();
        setLevel(++currentLevel);
      });
    }
  }

  void gravitycheck(
    BuildContext context,
    ModelPosition endPos,
  ) {
    //If piece has empty below
    if (!(endPos.y + 1 != 10 && board[endPos.y + 1][endPos.x].isEmpty())) {
      return;
    }
    //Get old piece
    EnumBoardPiece piece = board[endPos.y][endPos.x];
    board[endPos.y][endPos.x] = EnumBoardPiece.blank;
    notifyListeners();
    //Calculat the last position
    int newY = endPos.y + 1;
    while (newY + 1 != 10 && board[newY + 1][endPos.x].isEmpty()) {
      newY++;
    }
    if (newY == 10) newY--;
    OverlayEntry entry;
    entry = OverlayEntry(
        builder: (context) => OverlayPiece(
              start: endPos,
              end: ModelPosition(endPos.x, newY),
              piece: piece,
            ));
    Overlay.of(context).insert(entry);
    isMoveAnimationInProgress = true;
    Future.delayed(const Duration(milliseconds: 599), () {
      isMoveAnimationInProgress = false;
      board[newY][endPos.x] = piece;
      notifyListeners();
      entry.remove();
    });
  }

  bool isMoveAnimationInProgress = false;

  void removeSuggestions() {
    for (int i = 0; i < Constants.numVerticalBoxes; i++) {
      for (int j = 0; j < Constants.numHorizontalBoxes; j++) {
        if (board[i][j].isSuggested()) {
          board[i][j] = EnumBoardPiece.blank;
        }
      }
    }
    notifyListeners();
  }

  void updateSuggestions() {
    List<ModelPosition> possibles = Utils.getPossibleMove(board, selectedPiece.position!);
    for (ModelPosition pos in possibles) {
      if (board[pos.y][pos.x].isEmpty()) board[pos.y][pos.x] = EnumBoardPiece.suggested;
    }
    notifyListeners();
  }

  switchMusic() async {
    isMusicAllowed = !isMusicAllowed;
    if (isMusicAllowed) {
      audioBackground.setReleaseMode(ReleaseMode.loop);
      audioBackground.play(AssetSource("music.mp3"));
    } else {
      audioBackground.stop();
    }
    notifyListeners();
  }

  audioPlayMove({bool isKill = false}) async {
    if (!isMusicAllowed) return;
    String music = "move.mp3";
    if (isKill) {
      music = "kill.mp3";
    }
    await audioMove.play(AssetSource(music));
  }

  audioPlayMusic() async {
    // await audioBackground.play(AssetSource("music.mp3"));
  }

  ProvGame() {
    //Start the Game
    audioCacheBackground = AudioCache();
    audioCacheMove = AudioCache();
    audioBackground = AudioPlayer();
    audioMove = AudioPlayer();
    selectedPiece = SelectedPiece();
    for (int i = 0; i < 10; i++) {}
    boardKeys = List.generate(10, (index) {
      return List.generate(Constants.numHorizontalBoxes, (index) => GlobalKey());
    });
    //Load the Game
    currentLevel = 0;
    board = convertBoard(LocalData.levels.first.map((element) => List<int>.from(element)).toList());
    // board = LocalData.levels.first.map((element) => List<int>.from(element)).toList();
  }

  List<List<EnumBoardPiece>> convertBoard(List<List<int>> board) {
    final translatedBoard = List<List<EnumBoardPiece>>.generate(Constants.numVerticalBoxes, (index) => List<EnumBoardPiece>.generate(Constants.numHorizontalBoxes, (index) => EnumBoardPiece.blank));

    for (int i = 0; i < Constants.numVerticalBoxes; i++) {
      for (int j = 0; j < Constants.numHorizontalBoxes; j++) {
        translatedBoard[i][j] = EnumBoardPiece.values[board[i][j]];
      }
    }
    return translatedBoard;
  }
}
