import 'package:chesscursion_creator/config/enums.dart';
import 'package:chesscursion_creator/config/utils.dart';
import 'package:chesscursion_creator/models/model_position.dart';
import 'package:chesscursion_creator/providers/prov_prefs.dart';
import 'package:chesscursion_creator/screens/widgets/cell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverlayPawnPromotion extends StatefulWidget {
  const OverlayPawnPromotion({Key? key, required this.chosenPiece}) : super(key: key);
  final Function(EnumBoardPiece chosenPiece) chosenPiece;

  @override
  State<OverlayPawnPromotion> createState() => _OverlayPawnPromotionState();
}

class _OverlayPawnPromotionState extends State<OverlayPawnPromotion> {

  void handleSelection(EnumBoardPiece piece) {
    widget.chosenPiece(piece);
  }

  @override
  Widget build(BuildContext context) {
    double cellSize = context.read<ProvPrefs>().cellSize;
    return Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisSize: MainAxisSize.min,

            children: [
              GestureDetector(
                  onTap: () {
                    handleSelection(EnumBoardPiece.whiteRook);
                  },
                  child: Utils.getIcon(EnumBoardPiece.whiteRook, cellSize * 2)),
              SizedBox(
                width: 10,
              ),
              GestureDetector(onTap: () {
                handleSelection(EnumBoardPiece.whiteKnight);
              }, child: Utils.getIcon(EnumBoardPiece.whiteKnight, cellSize * 2)),
              SizedBox(
                width: 10,
              ),
              GestureDetector(onTap: () {
                handleSelection(EnumBoardPiece.whiteBishop);
              
              }, child: Utils.getIcon(EnumBoardPiece.whiteBishop, cellSize * 2)),
              SizedBox(
                width: 10,
              ),
              GestureDetector(onTap: () {
                handleSelection(EnumBoardPiece.whiteQueen);
              }, child: Utils.getIcon(EnumBoardPiece.whiteQueen, cellSize * 2)),
            ],
          ),
        ));
  }
}
