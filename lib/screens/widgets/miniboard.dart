import 'package:chesscursion_creator/config/constants.dart';
import 'package:chesscursion_creator/config/enums.dart';
import 'package:chesscursion_creator/screens/widgets/cell.dart';
import 'package:flutter/material.dart';

class MiniBoard extends StatelessWidget {
  const MiniBoard({super.key, required this.board, required this.onTap});
  final List<List<List<EnumBoardPiece>>> board;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (int ind = 0; ind < Constants.numVerticalBoxes; ind++)
            Row(
              mainAxisAlignment: MainAxisAlignment.center ,
              children: [
                for (int index = 0; index < Constants.numHorizontalBoxes; index++)
                  Cell(
                    key: ValueKey("$ind$index"),
                    index: index + (ind * Constants.numHorizontalBoxes),
                    cellContent: board[ind][index],
                    size: 10,
                    onTap: onTap,
                  )
              ],
            ),
        ],
      ),
    );
  }
}
