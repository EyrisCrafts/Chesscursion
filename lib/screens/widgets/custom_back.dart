import 'package:chesscursion_creator/config/constants.dart';
import 'package:flutter/material.dart';

class CustomBack extends StatelessWidget {
  const CustomBack({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
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
            color: Constants.colorSecondary,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 10,
          ),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          )),
    );
  }
}
