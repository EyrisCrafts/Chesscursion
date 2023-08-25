import 'package:chesscursion_creator/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class CustomToast {
  static showToast(String message, {Widget? leadingIcon}) {
    showToastWidget(
      Material(
          color: Colors.transparent,
          child: Builder(builder: (context) {
            final totalWidth = MediaQuery.of(context).size.width;

            return Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                width: totalWidth * 0.5,
                height: 50,
                decoration: BoxDecoration(boxShadow: [BoxShadow(offset: Offset(0, 0), blurRadius: 3, color: Colors.grey)], color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (leadingIcon != null) leadingIcon,
                        if (leadingIcon != null) const SizedBox(width: 10),
                        Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Constants.colorSecondary, fontWeight: FontWeight.w600)),
                      ],
                    )));
          })),
      position: ToastPosition.bottom,
    );
  }
}
