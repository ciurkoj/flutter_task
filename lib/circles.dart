import 'dart:math';

import 'package:flutter/material.dart';

class Circles extends StatefulWidget {
  final void Function(Offset) onChange;

  const Circles({
    // required Key key,
    required this.onChange,
  });
  //  : super(key: key);

  CirclesState createState() => CirclesState();
}

class CirclesState extends State {
  Offset delta = Offset.zero;
  double fieldRadius = 100;
  double buttonRadius = 25;

  void updateDelta(Offset newDelta) {
    // widget.onChange(newDelta);
    setState(() {
      delta = newDelta;
    });
  }

  @override
  initState() {
    super.initState();
  }
  void calculateDelta(Offset offset, double radius) {
    Offset newDelta = offset - Offset((radius / 2), (radius / 2));
    updateDelta(
      Offset.fromDirection(
        newDelta.direction,
        min(radius/2- buttonRadius/2, newDelta.distance),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    fieldRadius = (MediaQuery.of(context).size.width).floorToDouble() - 50;
    buttonRadius = fieldRadius/4;
    return Center(
      child: SizedBox(
        height: fieldRadius,
        width: fieldRadius,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Transform.translate(
                  offset: delta,
                  child: Container(
                    height: buttonRadius,
                    width: buttonRadius,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            onPanDown: onDragDown,
            onPanUpdate: onDragUpdate,
            onPanEnd: onDragEnd,
          ),
        ),
      ),
    );
  }

  void onDragDown(DragDownDetails d) {
    calculateDelta(d.localPosition, fieldRadius);
  }

  void onDragUpdate(DragUpdateDetails d) {
    calculateDelta(d.localPosition, fieldRadius);
  }

  void onDragEnd(DragEndDetails d) {
  }
}