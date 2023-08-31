import 'package:chesscursion_creator/config/constants.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({super.key, required this.onPressed, required this.icon, this.isSelected = false, this.defaultSize = true});
  final Function() onPressed;
  final IconData icon;
  final bool isSelected;
  final bool defaultSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
            alignment: Alignment.center,
            height: defaultSize ? null : 45,
            width: defaultSize ? null : 45,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                )
              ],
              color: isSelected ? Constants.cellColorDark : Colors.white,
              shape: BoxShape.circle,
            ),
            padding: defaultSize ?  const EdgeInsets.symmetric(horizontal: 15, vertical: 15) : null,
            child: Icon(icon, size: defaultSize ? (constraints.maxWidth / 3) / 2 : 15, color: isSelected ? Colors.white : Constants.colorSecondary)),
      );
    });
  }
}
