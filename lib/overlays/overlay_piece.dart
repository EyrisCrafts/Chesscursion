import 'package:chesscursion_creator/config/enums.dart';
import 'package:chesscursion_creator/config/utils.dart';
import 'package:chesscursion_creator/models/model_position.dart';
import 'package:chesscursion_creator/providers/prov_prefs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverlayPiece extends StatefulWidget {
  const OverlayPiece({Key? key, required this.start, required this.end, required this.piece}) : super(key: key);
  final ModelPosition start;
  final ModelPosition end;
  final EnumBoardPiece piece;

  @override
  State<OverlayPiece> createState() => _OverlayPieceState();
}

class _OverlayPieceState extends State<OverlayPiece> {
  late double top;
  late double left;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    List<double> pos = widget.start.getAbsolutePosition();
    top = pos[1];
    left = pos[0];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      List<double> pos = widget.end.getAbsolutePosition();
      top = pos[1];
      left = pos[0];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double cellSize = context.read<ProvPrefs>().cellSize;
    return AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
        top: top,
        left: left,
        child: Container(
          height: cellSize,
          width: cellSize,
          alignment: Alignment.center,
          child: Utils.getIcon(widget.piece, cellSize),
        ));
  }
}
