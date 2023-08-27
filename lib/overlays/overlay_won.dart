import 'package:flutter/material.dart';

class OverlayWon extends StatefulWidget {
  const OverlayWon({Key? key}) : super(key: key);

  @override
  State<OverlayWon> createState() => _OverlayWonState();
}

class _OverlayWonState extends State<OverlayWon> {
  bool visibile = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        visibile = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedOpacity(
        opacity: visibile ? 1 : 0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeIn,
        child: Container(
          alignment: Alignment.center,
          color: Colors.black.withOpacity(0.4),
          child: const Material(
            color: Colors.transparent,
            child: Text("You have Won !", style: TextStyle(color: Colors.white, fontSize: 40, fontFamily: "Marko One")),
          ),
        ),
      ),
    );
  }
}
