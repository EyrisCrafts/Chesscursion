// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:chesscursion_creator/config/constants.dart';
import 'package:chesscursion_creator/providers/prov_game.dart';

class ModelPosition {
  int x;
  int y;
  ModelPosition(this.x, this.y);
  bool isWithinBounds() {
    return y > -1 && y < Constants.numVerticalBoxes && x < Constants.numHorizontalBoxes && x > -1;
  }

  List<double> getAbsolutePosition() {
    final render = GetIt.I<ProvGame>().boardKeys[y][x].currentContext!.findRenderObject() as RenderBox;
    final offset = render.localToGlobal(Offset.zero);

    return [offset.dx, offset.dy];
  }

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }

  @override
  int get hashCode => (x.toString() + y.toString()).hashCode;

  ModelPosition copyWith({
    int? x,
    int? y,
  }) {
    return ModelPosition(
      x ?? this.x,
      y ?? this.y,
    );
  }
}
