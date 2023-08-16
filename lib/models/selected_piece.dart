// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chesscursion_creator/config/enums.dart';
import 'package:chesscursion_creator/models/model_position.dart';

class SelectedPiece {
  bool isSelected = false;
  EnumBoardPiece? selectedPiece;
  ModelPosition? position;

  SelectedPiece({
    this.isSelected = false,
    this.selectedPiece,
    this.position,
  });
}
