import 'package:chesscursion_creator/config/enums.dart';

extension ChessBoardUtils on EnumBoardPiece {
  bool isEmpty() {
    return this == EnumBoardPiece.blank || this == EnumBoardPiece.suggested;
  }

  bool isStep() {
    return this == EnumBoardPiece.step;
  }

  bool isBlock() {
    return this == EnumBoardPiece.block;
  }

  bool isPieceBlack() {
    if (name.toLowerCase().contains('black')) {
      return true;
    }
    return false;
  }

  bool isPieceWhite() {
    if (name.toLowerCase().contains('white')) {
      return true;
    }
    return false;
  }

  bool isChessPiece() {
    return isPieceBlack() || isPieceWhite();
  }

  bool isSuggested() {
    return this == EnumBoardPiece.suggested;
  }
}

extension ChessBoardUtilsList on List<EnumBoardPiece> {
  bool cellContains(EnumBoardPiece piece) {
    if (contains(piece)) {
      return true;
    }
    return false;
  }
}
