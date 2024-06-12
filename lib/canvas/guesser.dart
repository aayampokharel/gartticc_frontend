import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

class guesserContainer extends StatelessWidget {
  DrawingController guesserController;

  guesserContainer(this.guesserController);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 300,
        height: 300,
        color: const Color.fromARGB(255, 11, 185, 109),
        child: DrawingBoard(
          controller: guesserController,
          background: const SizedBox(width: 300, height: 300),
          showDefaultActions: false,
          showDefaultTools: false,
        ),
      ),
    );
  }
}
