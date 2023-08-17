import 'package:chesscursion_creator/config/enums.dart';
import 'package:chesscursion_creator/config/extensions.dart';
import 'package:chesscursion_creator/models/model_position.dart';
import 'package:chesscursion_creator/providers/prov_prefs.dart';
import 'package:chesscursion_creator/screens/widgets/cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import 'constants.dart';

enum UniqueChessPieces { king, queen, bishop, knight, rook, pawn }

class Utils {
  static Widget iconWidget(IconData iconData, double cellSize, {Color color = Colors.white, double size = -1}) {
    return Icon(iconData, color: color, size: size == -1 ? cellSize - 5 : size);
  }

  static Widget iconSvg(
    String path,
  ) {
    double cellSize = GetIt.I<ProvPrefs>().cellSize;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      height: cellSize - 10,
      alignment: Alignment.center,
      width: cellSize - 10,
      child: SvgPicture.asset(path, width: cellSize - 10, height: cellSize - 10, ),
    );
  }

  static Widget getIcon(EnumBoardPiece piece, double cellSize) {
    switch (piece) {
      case EnumBoardPiece.blank:
        return const SizedBox();
      case EnumBoardPiece.lock:
        return iconSvg("assets/icon_lock.svg");
      case EnumBoardPiece.key:
        return iconSvg("assets/icon_key.svg");
      case EnumBoardPiece.step:
        return iconWidget(FontAwesomeIcons.upLong, cellSize, color: Colors.black, size: cellSize - 2);
      case EnumBoardPiece.block:
        return iconWidget(FontAwesomeIcons.squareXmark, cellSize, color: Colors.black, size: cellSize - 2);
      case EnumBoardPiece.suggested:
        return const CellSuggested();
      case EnumBoardPiece.whiteKing:
        return iconWidget(FontAwesomeIcons.solidChessKing, cellSize, color: Colors.white);
      case EnumBoardPiece.whiteQueen:
        return iconWidget(FontAwesomeIcons.solidChessQueen, cellSize, color: Colors.white);
      case EnumBoardPiece.whiteBishop:
        return iconWidget(FontAwesomeIcons.solidChessBishop, cellSize, color: Colors.white);
      case EnumBoardPiece.whiteKnight:
        return iconWidget(FontAwesomeIcons.solidChessKnight, cellSize, color: Colors.white);
      case EnumBoardPiece.whiteRook:
        return iconWidget(FontAwesomeIcons.solidChessRook, cellSize, color: Colors.white);
      case EnumBoardPiece.whitePawn:
        return iconWidget(FontAwesomeIcons.solidChessPawn, cellSize, color: Colors.white);
      case EnumBoardPiece.blackKing:
        return iconWidget(FontAwesomeIcons.solidChessKing, cellSize, color: Colors.black);
      case EnumBoardPiece.blackQueen:
        return iconWidget(FontAwesomeIcons.solidChessQueen, cellSize, color: Colors.black);
      case EnumBoardPiece.blackBishop:
        return iconWidget(FontAwesomeIcons.solidChessBishop, cellSize, color: Colors.black);
      case EnumBoardPiece.blackKnight:
        return iconWidget(FontAwesomeIcons.solidChessKnight, cellSize, color: Colors.black);
      case EnumBoardPiece.blackRook:
        return iconWidget(FontAwesomeIcons.solidChessRook, cellSize, color: Colors.black);
      case EnumBoardPiece.blackPawn:
        return iconWidget(FontAwesomeIcons.solidChessPawn, cellSize, color: Colors.black);
    }
  }

  // Is the position where piece will be moved TO valid?
  static bool isPieceDestinationValid(List<List<List<EnumBoardPiece>>> board, ModelPosition endPosition) {
    // Within bounds and empty or black piece or Step
    return endPosition.isWithinBounds() &&
        (board[endPosition.y][endPosition.x][0].isEmpty() || board[endPosition.y][endPosition.x][0].isPieceBlack() || board[endPosition.y][endPosition.x][0].isStep() || board[endPosition.y][endPosition.x].cellContains(EnumBoardPiece.key));
  }

  //All possible moves of a piece
  static List<ModelPosition> getPossibleMove(List<List<List<EnumBoardPiece>>> board, ModelPosition position) {
    EnumBoardPiece piece = board[position.y][position.x][0];
    List<ModelPosition> toReturn = [];
    switch (piece) {
      case EnumBoardPiece.blank:
      case EnumBoardPiece.lock:
      case EnumBoardPiece.key:
      case EnumBoardPiece.block:
      case EnumBoardPiece.step:
      case EnumBoardPiece.suggested:
      case EnumBoardPiece.blackKing:
      case EnumBoardPiece.blackQueen:
      case EnumBoardPiece.blackBishop:
      case EnumBoardPiece.blackKnight:
      case EnumBoardPiece.blackRook:
      case EnumBoardPiece.blackPawn:
      case EnumBoardPiece.whitePawn:
        // Only top if top is empty or step
        if (!board[position.y - 1][position.x].cellContains(EnumBoardPiece.step)) {
          return [ModelPosition(position.x, position.y - 1)];
        }

        if (board[position.y - 1][position.x].cellContains(EnumBoardPiece.step)) {
          return [ModelPosition(position.x, position.y - 1), ModelPosition(position.x, position.y - 2)];
        }

        return [];
      case EnumBoardPiece.whiteKing:
        for (int i = -1; i < 2; i++) {
          for (int j = -1; j < 2; j++) {
            final ModelPosition pos1 = ModelPosition(position.x + i, position.y + j);
            if (isPieceDestinationValid(board, pos1)) {
              toReturn.add(pos1);
            }
          }
        }
        return toReturn;
      case EnumBoardPiece.whiteKnight:
        final ModelPosition pos1 = ModelPosition(position.x - 1, position.y - 2);
        if (isPieceDestinationValid(board, pos1)) {
          // if (pos1.isWithinBounds() && (board[pos1.y][pos1.x].isEmpty() || board[pos1.y][pos1.x].isPieceBlack())) {
          toReturn.add(pos1);
        }
        final ModelPosition pos2 = ModelPosition(position.x + 1, position.y - 2);
        if (isPieceDestinationValid(board, pos2)) {
          toReturn.add(pos2);
        }
        final ModelPosition pos3 = ModelPosition(position.x - 1, position.y + 2);
        if (isPieceDestinationValid(board, pos3)) {
          toReturn.add(pos3);
        }
        final ModelPosition pos4 = ModelPosition(position.x + 1, position.y + 2);
        if (isPieceDestinationValid(board, pos4)) {
          toReturn.add(pos4);
        }

        final ModelPosition pos5 = ModelPosition(position.x + 2, position.y + 1);
        if (isPieceDestinationValid(board, pos5)) {
          toReturn.add(pos5);
        }

        final ModelPosition pos6 = ModelPosition(position.x + 2, position.y - 1);
        if (isPieceDestinationValid(board, pos6)) {
          toReturn.add(pos6);
        }

        final ModelPosition pos7 = ModelPosition(position.x - 2, position.y - 1);
        if (isPieceDestinationValid(board, pos7)) {
          toReturn.add(pos7);
        }

        final ModelPosition pos8 = ModelPosition(position.x - 2, position.y + 1);
        if (isPieceDestinationValid(board, pos8)) {
          toReturn.add(pos8);
        }
        return toReturn;
      case EnumBoardPiece.whiteQueen:
        return [...getPossibleDiagonals(board, position), ...getPossibleStraights(board, position)];
      case EnumBoardPiece.whiteBishop:
        return getPossibleDiagonals(board, position);
      case EnumBoardPiece.whiteRook:
        return getPossibleStraights(board, position);
    }
  }

  static List<List<List<EnumBoardPiece>>> convertBoard(List<List<List<int>>> board) {
    final translatedBoard = List<List<List<EnumBoardPiece>>>.generate(Constants.numVerticalBoxes, (index) => List<List<EnumBoardPiece>>.generate(Constants.numHorizontalBoxes, (index) => []));

    for (int i = 0; i < Constants.numVerticalBoxes; i++) {
      for (int j = 0; j < Constants.numHorizontalBoxes; j++) {
        for (int k = 0; k < board[i][j].length; k++) {
          translatedBoard[i][j].add(EnumBoardPiece.values[board[i][j][k]]);
        }
      }
    }
    return translatedBoard;
  }

  static List<List<List<int>>> convertBoardToRaw(List<List<List<EnumBoardPiece>>> board) {
    final translatedBoard = List<List<List<int>>>.generate(Constants.numVerticalBoxes, (index) => List<List<int>>.generate(Constants.numHorizontalBoxes, (index) => []));

    for (int i = 0; i < Constants.numVerticalBoxes; i++) {
      for (int j = 0; j < Constants.numHorizontalBoxes; j++) {
        for (int k = 0; k < board[i][j].length; k++) {
          translatedBoard[i][j].add(EnumBoardPiece.values.indexOf(board[i][j][k]));
        }
      }
    }
    return translatedBoard;
  }

  static List<ModelPosition> getPossibleStraights(List<List<List<EnumBoardPiece>>> board, ModelPosition position) {
    List<ModelPosition> toReturn = [];
    //Left all the way
    for (int i = position.x - 1; i != -1; i--) {
      if (isPieceDestinationValid(board, ModelPosition(i, position.y))) {
        toReturn.add(ModelPosition(i, position.y));
        // } else if (board[position.y][i].isPieceBlack()) {
        //   toReturn.add(ModelPosition(i, position.y));
        //   break;
      } else {
        break;
      }
    }
    //Right all the way
    for (int i = position.x + 1; i != Constants.numHorizontalBoxes; i++) {
      if (isPieceDestinationValid(board, ModelPosition(i, position.y))) {
        toReturn.add(ModelPosition(i, position.y));
        // } else if (board[position.y][i].isPieceBlack()) {
        //   toReturn.add(ModelPosition(i, position.y));
        //   break;
      } else {
        break;
      }
    }

    //Bottom all the way
    for (int i = position.y + 1; i != 10; i++) {
      if (isPieceDestinationValid(board, ModelPosition(position.x, i))) {
        toReturn.add(ModelPosition(position.x, i));
        // } else if (board[i][position.x].isPieceBlack()) {
        //   toReturn.add(ModelPosition(position.x, i));
        //   break;
      } else {
        break;
      }
    }
    //Top all the way
    for (int i = position.y - 1; i != -1; i--) {
      if (isPieceDestinationValid(board, ModelPosition(position.x, i))) {
        toReturn.add(ModelPosition(position.x, i));
        // } else if (board[i][position.x].isPieceBlack()) {
        //   toReturn.add(ModelPosition(position.x, i));
        //   break;
      } else {
        break;
      }
    }

    return toReturn;
  }

  static List<ModelPosition> getPossibleDiagonals(List<List<List<EnumBoardPiece>>> board, ModelPosition position) {
    List<ModelPosition> toReturn = [];
    //Bottom right
    for (int i = position.x + 1, j = position.y + 1; i != Constants.numHorizontalBoxes && j != 10; i++, j++) {
      if (isPieceDestinationValid(board, ModelPosition(i, j))) {
        toReturn.add(ModelPosition(i, j));
        // } else if (board[j][i].isPieceBlack()) {
        //   toReturn.add(ModelPosition(i, j));
        //   break;
      } else {
        break;
      }
    }
    //Top right
    for (int i = position.x + 1, j = position.y - 1; i != Constants.numHorizontalBoxes && j != -1; i++, j--) {
      if (isPieceDestinationValid(board, ModelPosition(i, j))) {
        toReturn.add(ModelPosition(i, j));
        // } else if (board[j][i].isPieceBlack()) {
        //   toReturn.add(ModelPosition(i, j));
        //   break;
      } else {
        break;
      }
    }
    //Bottom left
    for (int i = position.x - 1, j = position.y + 1; i != -1 && j != 10; i--, j++) {
      if (isPieceDestinationValid(board, ModelPosition(i, j))) {
        toReturn.add(ModelPosition(i, j));
        // } else if (board[j][i].isPieceBlack()) {
        //   toReturn.add(ModelPosition(i, j));
        //   break;
      } else {
        break;
      }
    }
    //Top left
    for (int i = position.x - 1, j = position.y - 1; i != -1 && j != -1; i--, j--) {
      if (isPieceDestinationValid(board, ModelPosition(i, j))) {
        toReturn.add(ModelPosition(i, j));
        // } else if (board[j][i].isPieceBlack()) {
        //   toReturn.add(ModelPosition(i, j));
        //   break;
      } else {
        break;
      }
    }
    return toReturn;
  }
}
