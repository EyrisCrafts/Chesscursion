import 'package:chesscursion_creator/config/constants.dart';
import 'package:chesscursion_creator/config/enums.dart';
import 'package:chesscursion_creator/config/utils.dart';
import 'package:chesscursion_creator/providers/prov_prefs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cell extends StatelessWidget {
  const Cell({Key? key, required this.index, required this.cellContent, required this.onTap, this.size = 0}) : super(key: key);
  final int index;
  final List<EnumBoardPiece> cellContent;
  final Function() onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    double cellSize = context.read<ProvPrefs>().cellSize;
    if (size != 0) {
      cellSize = size;
    }
    final stackContent = cellContent.toList();
    // swap position of step to 0
    final stepPosition = stackContent.indexOf(EnumBoardPiece.step);
    if (stepPosition != -1) {
      stackContent.insert(0, stackContent.removeAt(stepPosition));
    }

    final buttonPosition = stackContent.indexOf(EnumBoardPiece.buttonPressed);
    if (buttonPosition != -1) {
      stackContent.insert(0, stackContent.removeAt(buttonPosition));
    }
    
    final doorPosition = stackContent.indexOf(EnumBoardPiece.doorDeactivated);
    if (doorPosition != -1) {
      stackContent.insert(0, stackContent.removeAt(doorPosition));
    }
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: cellSize,
        width: cellSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: ((index + (index ~/ Constants.numHorizontalBoxes)) % 2) == 0 ? Constants.cellColorLight : Constants.cellColorDark),
        child: Stack(
          children: List.generate(stackContent.length, (index) => Utils.getIcon(stackContent[index], cellSize)),
        ),
      ),
    );
  }
}

class CellSuggested extends StatefulWidget {
  const CellSuggested({Key? key}) : super(key: key);

  @override
  State<CellSuggested> createState() => _CellSuggestedState();
}

class _CellSuggestedState extends State<CellSuggested> {
  double visibilty = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      toggleVisibilty();
    });
  }

  void toggleVisibilty() async {
    await Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          visibilty = visibilty == 0 ? 1 : 0;
        });
      }
    });
    if (mounted) {
      toggleVisibilty();
    }
  }

  @override
  Widget build(BuildContext context) {
    double cellSize = context.read<ProvPrefs>().cellSize;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      height: cellSize - 10,
      width: cellSize - 10,
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3 * (visibilty + 0.1)), shape: BoxShape.circle),
    );
  }
}
