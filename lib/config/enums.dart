enum EnumBoardPiece {
  blank,
  block,
  suggested,
  whiteKing,
  whiteQueen,
  whiteBishop,
  whiteKnight,
  whiteRook,
  whitePawn,
  blackKing,
  blackQueen,
  blackBishop,
  blackKnight,
  blackRook,
  blackPawn,
  step,
}

// Step Rules

// 1. Pawn can click on the step, and go over it.
// 2. Any other piece just falls
// 3. Rook can pass through the stop, but gravity stops it on it.
