import 'package:chesscursion_creator/config/constants.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({super.key, required this.text, required this.onPressed, this.width = 200, this.fontSize = 22, this.inverseColors = false});
  final String text;
  final Function() onPressed;
  final double width;
  final double fontSize;
  final bool inverseColors;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: widget.width,
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
          color: widget.inverseColors ? Colors.white : Constants.colorSecondary,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Text(
          widget.text,
          style: TextStyle(fontFamily: "Marko One", fontSize: widget.fontSize, color: widget.inverseColors ? Constants.colorSecondary : Colors.white),
        ),
      ),
    );
  }
}