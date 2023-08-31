import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:chesscursion_creator/config/constants.dart';
import 'package:chesscursion_creator/config/enums.dart';
import 'package:chesscursion_creator/config/extensions.dart';
import 'package:chesscursion_creator/config/local_data.dart';
import 'package:chesscursion_creator/config/utils.dart';
import 'package:chesscursion_creator/models/model_position.dart';
import 'package:chesscursion_creator/models/selected_piece.dart';
import 'package:chesscursion_creator/overlays/overlay_pawn_promotion.dart';
import 'package:chesscursion_creator/overlays/overlay_piece.dart';
import 'package:chesscursion_creator/overlays/overlay_won.dart';
import 'package:chesscursion_creator/providers/prov_creator.dart';
import 'package:chesscursion_creator/providers/prov_music.dart';
import 'package:chesscursion_creator/providers/prov_user.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProvGame extends ChangeNotifier {
  List<List<List<EnumBoardPiece>>> board = [];
  late SelectedPiece selectedPiece;
  List<List<GlobalKey>> boardKeys = [];
  late int currentLevel;
  late AudioPlayer audioBackground;
  late AudioPlayer audioMove;
  late AudioCache audioCacheBackground;
  late AudioCache audioCacheMove;
  bool isMusicAllowed = true;

  EnumGameMode enumGameMode = EnumGameMode.normal;
  bool isDeveloperMode = false;

  bool isFlying = false;
  bool isBlackTurn = false;

  void updateGameMode(EnumGameMode enumGameMode, {bool shouldNotify = true}) {
    this.enumGameMode = enumGameMode;
    notifyListeners();
  }

  bool isPieceOnBoard(EnumBoardPiece piece) {
    for (int my = 0; my < Constants.numVerticalBoxes; my++) {
      for (int mx = 0; mx < Constants.numHorizontalBoxes; mx++) {
        if (board[my][mx].cellContains(piece)) {
          return true;
        }
      }
    }
    return false;
  }

  void onCellTapped(int x, int y, BuildContext context) {
    if (isBlackTurn) return;
    final oldPosition = selectedPiece.position?.copyWith();
    // if in create mode and not creator play mode
    if (enumGameMode == EnumGameMode.creatorCreate) {
      if (GetIt.I<ProvCreator>().selectedPiece! == EnumBoardPiece.blank) {
        board[y][x] = [EnumBoardPiece.blank];
      } else if (GetIt.I<ProvCreator>().selectedPiece!.isPieceBlack() || GetIt.I<ProvCreator>().selectedPiece!.isPieceWhite() || GetIt.I<ProvCreator>().selectedPiece!.isBlock()) {
        board[y][x][0] = GetIt.I<ProvCreator>().selectedPiece!;
      } else {
        if (!board[y][x].cellContains(GetIt.I<ProvCreator>().selectedPiece!)) {
          board[y][x].add(GetIt.I<ProvCreator>().selectedPiece!);
        }
      }
      notifyListeners();
      return;
    }
    if (isMoveAnimationInProgress) return;
    if (board[y][x][0].isPieceWhite()) {
      removeSuggestions();
      selectedPiece.isSelected = true;
      selectedPiece.selectedPiece = board[y][x][0];
      selectedPiece.position = ModelPosition(x, y);

      updateSuggestions();
      return;
    }
    if (selectedPiece.isSelected) {
      if (Utils.getPossibleMove(board, selectedPiece.position!).contains(ModelPosition(x, y))) {
        ModelPosition finalDestination = ModelPosition(x, y);
        if (board[y][x][0].isStep()) {
          finalDestination = ModelPosition(x, y - 1);
        }

        // if destination is not a black piece, play move sound
        if (!board[finalDestination.y][finalDestination.x][0].isPieceBlack()) {
          // audioPlayMove();
          GetIt.I<ProvMusic>().move();
        } else {
          GetIt.I<ProvMusic>().kill();
          // audioPlayMove(isKill: true);
        }

        if (board[finalDestination.y][finalDestination.x].cellContains(EnumBoardPiece.key)) {
          removeAllLocks();
        }

        // If new place has a step, move on top of it
        board[selectedPiece.position!.y][selectedPiece.position!.x][0] = EnumBoardPiece.blank;
        board[finalDestination.y][finalDestination.x][0] = selectedPiece.selectedPiece!;

        // If cell contains a button, activate it
        buttonCheckForDestination();

        notifyListeners();
        checkPromotion(finalDestination, context);

        //Win check
        winCheckCondition(context);

        //Gravity Check !
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          isFlying = true;
          // New Gravity check
          final ModelPosition newPosition = await gravitycheck(context, ModelPosition(finalDestination.x, finalDestination.y));
          isFlying = false;
          if (board[newPosition.y][newPosition.x][0].isPieceWhite()) {
            selectedPiece.isSelected = true;
            selectedPiece.selectedPiece = board[newPosition.y][newPosition.x][0];
            selectedPiece.position = ModelPosition(newPosition.x, newPosition.y);
            stackingGravityCheck(ModelPosition(oldPosition!.x, oldPosition.y));

            checkIfBlackCanKill();
            updateSuggestions();
            buttonCheckForDestination();
            // WidgetsBinding.instance.addPostFrameCallback((a) {
            // });
          }
        });
      }
      selectedPiece.isSelected = false;
      removeSuggestions();
    }
    // Check if any black piece can kill the white piece
    // WidgetsBinding.instance.addPostFrameCallback((a) {
    // });
    checkIfBlackCanKill();
  }

  // Check when a piece has some other piece on top of it
  void stackingGravityCheck(ModelPosition stackPoint) {
    // If a white piece on top, and white space on bottom
    if ((stackPoint.y - 1).isWithinVerticalBounds() && board[stackPoint.y - 1][stackPoint.x][0].isPieceWhite()) {
      if (board[stackPoint.y][stackPoint.x][0].isEmpty() && !board[stackPoint.y][stackPoint.x].cellContains(EnumBoardPiece.step)) {
        // Move the piece down
        board[stackPoint.y][stackPoint.x][0] = board[stackPoint.y - 1][stackPoint.x][0];
        board[stackPoint.y - 1][stackPoint.x][0] = EnumBoardPiece.blank;
        stackingGravityCheck(ModelPosition(stackPoint.x, stackPoint.y - 1));
      }
    }
  }

  void checkIfBlackCanKill() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isBlackTurn = true;
      for (int my = 0; my < Constants.numVerticalBoxes; my++) {
        for (int mx = 0; mx < Constants.numHorizontalBoxes; mx++) {
          if (board[my][mx][0].isPieceBlack()) {
            List<ModelPosition> possibles = Utils.getPossibleMove(board, ModelPosition(mx, my), isBlackTurn: true);
            for (ModelPosition pos in possibles) {
              if (pos.x == selectedPiece.position!.x && pos.y == selectedPiece.position!.y) {
                // If destination is not a black piece, play move sound
                // audioPlayMove(isKill: true);
                GetIt.I<ProvMusic>().kill();

                board[selectedPiece.position!.y][selectedPiece.position!.x][0] = board[my][mx][0];
                board[my][mx][0] = EnumBoardPiece.blank;
                removeSuggestions(shouldNotify: false);
                notifyListeners();
                isBlackTurn = false;
                return;
              }
            }
          }
        }
      }
      isBlackTurn = false;
    });
  }

  void checkPromotion(ModelPosition endPosition, BuildContext context) {
    if (board[endPosition.y][endPosition.x][0] == EnumBoardPiece.whitePawn && endPosition.y == 0) {
      OverlayEntry? entry;
      entry = OverlayEntry(
          builder: (context) => OverlayPawnPromotion(
                chosenPiece: (EnumBoardPiece chosenPiece) {
                  board[endPosition.y][endPosition.x][0] = chosenPiece;
                  notifyListeners();
                  entry?.remove();
                },
              ));
      Overlay.of(context).insert(entry);
    }
  }

  // When a piece is moved.
  void buttonCheckForDestination() {
    for (int i = 0; i < Constants.numVerticalBoxes; i++) {
      for (int j = 0; j < Constants.numHorizontalBoxes; j++) {
        // If button pressed but not piece on it
        if (board[i][j].cellContains(EnumBoardPiece.buttonPressed) && !board[i][j][0].isPieceWhite()) {
          board[i][j].remove(EnumBoardPiece.buttonPressed);
          board[i][j].add(EnumBoardPiece.buttonUnpressed);
          updateDoorActivation(false);
        }
        // If button unpressed but piece on it
        if (board[i][j].cellContains(EnumBoardPiece.buttonUnpressed) && board[i][j][0].isPieceWhite()) {
          board[i][j].remove(EnumBoardPiece.buttonUnpressed);
          board[i][j].add(EnumBoardPiece.buttonPressed);
          updateDoorActivation(true);
        }
      }
    }
  }

  void updateDoorActivation(bool activate) {
    for (int i = 0; i < Constants.numVerticalBoxes; i++) {
      for (int j = 0; j < Constants.numHorizontalBoxes; j++) {
        // If there is a door, activate it
        if (!activate) {
          if (board[i][j].cellContains(EnumBoardPiece.doorDeactivated)) {
            board[i][j].remove(EnumBoardPiece.doorDeactivated);
            board[i][j].add(EnumBoardPiece.doorActivated);
          }
        } else {
          if (board[i][j].cellContains(EnumBoardPiece.doorActivated)) {
            board[i][j].remove(EnumBoardPiece.doorActivated);
            board[i][j].add(EnumBoardPiece.doorDeactivated);
          }
        }
      }
    }
  }

  void setLevel(int level) {
    if (level == LocalData.levels.length) level = 0;
    currentLevel = level;
    board = Utils.convertBoard(LocalData.levels[level].map((element) => List<List<int>>.from(element)).toList());
    selectedPiece.isSelected = false;
    notifyListeners();
  }

  void setBoard(List<List<List<EnumBoardPiece>>> newBoard, {bool shouldNotify = true}) {
    board = newBoard;
    selectedPiece.isSelected = false;
    if (shouldNotify) {
      notifyListeners();
    }
  }

  bool kingExists() {
    for (int my = 0; my < 10; my++) {
      for (int mx = 0; mx < Constants.numHorizontalBoxes; mx++) {
        if (board[my][mx][0] == EnumBoardPiece.blackKing) {
          return true;
        }
      }
    }
    return false;
  }

  bool checkingWinCondition = false;

  void winCheckCondition(BuildContext context) async {
    if (checkingWinCondition) return; // To make sure this function is only called once
    checkingWinCondition = true;
    await Future.delayed(const Duration(milliseconds: 200));
    if (!kingExists()) {
      GetIt.I<ProvMusic>().win();
      OverlayEntry entry = OverlayEntry(builder: (context) => const OverlayWon());
      Overlay.of(context).insert(entry);
      await Future.delayed(const Duration(milliseconds: 2000), () {
        entry.remove();
        // Go to creator create mode
        if (enumGameMode == EnumGameMode.creatorPlay) {
          GetIt.I<ProvCreator>().setCreatorMode(enumGameMode: EnumGameMode.creatorCreate);
          GetIt.I<ProvCreator>().resetBoard();
          return;
        } else if (enumGameMode == EnumGameMode.community) {
          Navigator.maybePop(context);
          return;
        }
        setLevel(++currentLevel);
        log("Level completed $currentLevel");
        GetIt.I<ProvUser>().setLevelsCompleted(currentLevel);
      });
    }
    checkingWinCondition = false;
  }

  ModelPosition findBottom(ModelPosition currentPosition) {
    log("finding bottom");
    if ((currentPosition.y + 1).isWithinVerticalBounds() && board[currentPosition.y + 1][currentPosition.x].cellContains(EnumBoardPiece.step)) {
      return currentPosition;
    }
    // if below is valid
    if (!Utils.isPieceDestinationValid(board, ModelPosition(currentPosition.x, currentPosition.y + 1))) {
      return currentPosition;
    } else {
      return findBottom(ModelPosition(currentPosition.x, currentPosition.y + 1));
    }
  }

  Future<ModelPosition> gravitycheck(
    BuildContext context,
    ModelPosition endPos,
  ) async {
    //If piece below is not black or block or out of bounds return
    if (!(endPos.y + 1 != 10 && (board[endPos.y + 1][endPos.x][0].isEmpty() || board[endPos.y + 1][endPos.x][0].isPieceBlack() || board[endPos.y + 1][endPos.x].cellContains(EnumBoardPiece.key)))) {
      return endPos;
    }
    if (board[endPos.y + 1][endPos.x].contains(EnumBoardPiece.step) ||
        board[endPos.y + 1][endPos.x].contains(EnumBoardPiece.lock) ||
        board[endPos.y + 1][endPos.x].contains(EnumBoardPiece.doorActivated)) {
      log("ca");
      return endPos;
    }

    log("c1 $endPos");
    //Get old piece
    EnumBoardPiece piece = board[endPos.y][endPos.x][0];
    board[endPos.y][endPos.x][0] = EnumBoardPiece.blank;
    notifyListeners();
    //Calculat the last position
    int newY = endPos.y + 1;
    // ModelPosition newPos = findBottom(endPos);
    // int newY = newPos.y;
    while (newY + 1 != 10 && (board[newY + 1][endPos.x][0].isEmpty() || board[newY + 1][endPos.x][0].isPieceBlack())) {
      if (board[newY + 1][endPos.x].cellContains(EnumBoardPiece.step) || board[newY + 1][endPos.x].cellContains(EnumBoardPiece.lock)) {
        break;
      }

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
    await Future.delayed(const Duration(milliseconds: 599), () {
      isMoveAnimationInProgress = false;
      if (board[newY][endPos.x][0].isPieceBlack()) {
        // audioPlayMove(isKill: true);
        GetIt.I<ProvMusic>().kill();
      }

      if (board[newY][endPos.x].cellContains(EnumBoardPiece.key)) {
        // TODO Key sound
        // audioPlayMove(isKill: true);
        
        // remove all locks
        removeAllLocks();
      }
      board[newY][endPos.x][0] = piece;
      notifyListeners();
      entry.remove();
      winCheckCondition(context);
    });
    return ModelPosition(endPos.x, newY);
  }

  // Remove all keys and locks
  void removeAllLocks() {
    GetIt.I<ProvMusic>().key();
    for (int my = 0; my < 10; my++) {
      for (int mx = 0; mx < Constants.numHorizontalBoxes; mx++) {
        if (board[my][mx].cellContains(EnumBoardPiece.lock) || board[my][mx].cellContains(EnumBoardPiece.key)) {
          board[my][mx].removeWhere((e) => e == EnumBoardPiece.lock);
          board[my][mx].removeWhere((e) => e == EnumBoardPiece.key);
        }
      }
    }
    notifyListeners();
  }

  bool isMoveAnimationInProgress = false;

  void removeSuggestions({bool shouldNotify = true}) {
    log("Removing suggestions");
    for (int i = 0; i < Constants.numVerticalBoxes; i++) {
      for (int j = 0; j < Constants.numHorizontalBoxes; j++) {
        board[i][j].removeWhere((element) => element == EnumBoardPiece.suggested);
      }
    }
    notifyListeners();
  }

  void updateSuggestions() {
    List<ModelPosition> possibles = Utils.getPossibleMove(board, selectedPiece.position!);
    for (ModelPosition pos in possibles) {
      board[pos.y][pos.x].add(EnumBoardPiece.suggested);
    }
    notifyListeners();
  }

  stopMusic() {
    audioBackground.stop();
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
    board = Utils.convertBoard(LocalData.levels.first.map((element) => List<List<int>>.from(element)).toList());
  }
}
