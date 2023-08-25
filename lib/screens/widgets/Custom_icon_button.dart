import 'package:chesscursion_creator/config/constants.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({super.key, required this.onPressed, required this.icon, this.isSelected = false});
  final Function() onPressed;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
            alignment: Alignment.center,
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Icon(icon, size: (constraints.maxWidth / 3) / 2, color: isSelected ? Colors.white : Constants.colorSecondary)),
      );
    });
  }
}
