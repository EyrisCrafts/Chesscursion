enum EnumBoardPiece {
  blank, // 0
  block, // 1
  suggested, // 2
  whiteKing, // 3
  whiteQueen, // 4
  whiteBishop, // 5
  whiteKnight, // 6
  whiteRook, //7
  whitePawn, //8
  blackKing, // 9
  blackQueen, // 10
  blackBishop, // 11
  blackKnight, // 12
  blackRook, // 13
  blackPawn, // 14
  step, // 15
  key, // 17
  lock, // 18
  buttonPressed, // 19
  buttonUnpressed, // 20
  doorActivated, // 21
  doorDeactivated // 22
}

enum EnumGameMode {
  normal,
  creatorCreate,
  creatorPlay,
  community
}

// Step Rules

// 1. Pawn can click on the step, and go over it.
// 2. Any other piece just falls
// 3. Rook can pass through the stop, but gravity stops it on it.
