import 'package:chesscursion_creator/config/enums.dart';
import 'package:chesscursion_creator/providers/prov_creator.dart';
import 'package:chesscursion_creator/providers/prov_game.dart';
import 'package:chesscursion_creator/providers/prov_prefs.dart';
import 'package:chesscursion_creator/screens/widgets/board.dart';
import 'package:chesscursion_creator/screens/widgets/cell.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ScreenGame extends StatefulWidget {
  const ScreenGame({Key? key}) : super(key: key);

  @override
  State<ScreenGame> createState() => _ScreenGameState();
}

class _ScreenGameState extends State<ScreenGame> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      GetIt.I<ProvGame>().audioPlayMusic();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      GetIt.I<ProvGame>().setLevel(0);
      if (GetIt.I<ProvCreator>().isCreatorMode) {
        GetIt.I<ProvCreator>().restartBoard();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const Expanded(child: Board()),
            Container(
                height: 100,
                color: Colors.pink.withOpacity(0.2),
                child: Wrap(children: [
                  ...List.generate(
                      EnumBoardPiece.values.length,
                      (index) => Consumer<ProvCreator>(builder: (context, provCreator, _) {
                            return Cell(
                              key: ValueKey(index),
                              index: provCreator.selectedPiece == EnumBoardPiece.values[index] ? 1 : 0,
                              cellContent: [EnumBoardPiece.values[index]],
                              onTap: () {
                                // Make it selected
                                GetIt.I<ProvCreator>().selectPiece(EnumBoardPiece.values[index]);
                              },
                            );
                          })),
                  IconButton.outlined(
                      onPressed: () {
                        // Save board to disk? to clipboard?
                        GetIt.I<ProvCreator>().saveBoard();
                      },
                      icon: Icon(Icons.save_alt)),
                  IconButton.outlined(
                      onPressed: () {
                        // Save board to disk? to clipboard?
                        GetIt.I<ProvCreator>().restartBoard();
                      },
                      icon: Icon(Icons.restart_alt_rounded)),
                ]))
          ],
        ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    GetIt.I<ProvPrefs>().setCellSize(context);
  }
}
