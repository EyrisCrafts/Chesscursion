import 'dart:developer';

import 'package:chesscursion_creator/config/constants.dart';
import 'package:chesscursion_creator/config/enums.dart';
import 'package:chesscursion_creator/config/utils.dart';
import 'package:flutter/material.dart';

class CreatorIcon extends StatelessWidget {
  const CreatorIcon({super.key, required this.piece, required this.isSelected, required this.onTap});
  final EnumBoardPiece piece;
  final bool isSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final buttonWidth = constraints.maxWidth * 0.4;
      final iconWidth = buttonWidth * 0.8;
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: buttonWidth,
          width: buttonWidth,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Constants.cellColorDark : Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3))]),
          child: Utils.getIcon(piece, iconWidth, isAlwaysCenter: true),
        ),
      );
    });
  }
}
