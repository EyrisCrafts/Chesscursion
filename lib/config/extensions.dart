import 'package:chesscursion_creator/config/constants.dart';
import 'package:chesscursion_creator/config/enums.dart';
import 'package:intl/intl.dart';

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

  // Returns the pieces that can be put. i.e suggestion, pressed door etc cannot be put
  List<EnumBoardPiece> getMaterialPieces() {
    return EnumBoardPiece.values.where((element) => element != EnumBoardPiece.buttonPressed && element != EnumBoardPiece.suggested && element != EnumBoardPiece.doorDeactivated).toList();
  }
}

extension DateHelper on DateTime {
  String formattedDate() {
    return DateFormat("dd/MM/yyyy h:m a").format(this);
  }

  String timeSince() {
    final nowTimestamp = DateTime.now();
    var difference = nowTimestamp.difference(this);

    if (difference.inDays > 3) {
      // If the comment is more than 3 days old, return the full timestamp.
      return DateFormat("dd/MM/yyyy h:m a").format(this);
    } else if (difference.inDays > 0) {
      return "${difference.inDays} day(s) ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hour(s) ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minute(s) ago";
    } else {
      return "Just now";
    }
  }
}

extension NumberHelper on int {
  bool isWithinVerticalBounds() {
    return this >= 0 && this < Constants.numVerticalBoxes ;
  }
}

extension GameTypeHelper on EnumGameMode {
  bool isCreaterMode() => this == EnumGameMode.creatorCreate || this == EnumGameMode.creatorPlay;
}
