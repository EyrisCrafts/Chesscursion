import 'package:chesscursion_creator/config/constants.dart';
import 'package:chesscursion_creator/config/enums.dart';
import 'package:chesscursion_creator/config/utils.dart';
import 'package:chesscursion_creator/providers/prov_prefs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cell extends StatelessWidget {
  const Cell({Key? key, required this.index, required this.item, required this.onTap}) : super(key: key);
  final int index;
  final EnumBoardPiece item;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    double cellSize = context.read<ProvPrefs>().cellSize;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: cellSize,
        width: cellSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: ((index + (index ~/ Constants.numHorizontalBoxes)) % 2) == 0 ? Constants.cellColorLight : Constants.cellColorDark),
        child: Utils.getIcon(item, cellSize),
      ),
    );
  }
}

class CellSuggested extends StatelessWidget {
  const CellSuggested({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cellSize = context.read<ProvPrefs>().cellSize;
    return Container(
      height: cellSize - 10,
      width: cellSize - 10,
      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.2), shape: BoxShape.circle),
    );
  }
}
