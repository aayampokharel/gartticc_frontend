import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:x/logic/paintChannel.dart';

class Drawing extends StatelessWidget {
  var singleValue;

  PaintChannel paintChannel;

  DrawingController drawingController;
  Drawing(this.singleValue, this.paintChannel, this.drawingController);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 19500),
          tween: Tween<double>(begin: 0, end: 300),
          builder: (BuildContext context, dynamic value, Widget? child) {
            return Container(
              height: 20,
              width: value,
              color: Colors.deepOrange,
            );
          },
        ),
        Container(
          //# THis is the text displayed for drawer.
          width: 300,
          padding: const EdgeInsets.all(10),
          color: Colors.pink,
          child: Text(singleValue.toString()),
        ),
        Container(
          width: 300,
          height: 300, //# for drawer calls getJsonList() to send the points.
          color: Colors.yellow,
          child: Listener(
            onPointerCancel: (s) {
              paintChannel
                  .getListJson(json.encode(drawingController.getJsonList()));
            },
            onPointerDown: (s) {
              paintChannel
                  .getListJson(json.encode(drawingController.getJsonList()));
            },
            onPointerMove: (s) {
              paintChannel
                  .getListJson(json.encode(drawingController.getJsonList()));
            },
            onPointerUp: (s) {
              paintChannel
                  .getListJson(json.encode(drawingController.getJsonList()));
            },
            child: DrawingBoard(
              controller: drawingController,
              background: const SizedBox(width: 300, height: 300),
              showDefaultActions: true,
              showDefaultTools: true,
            ),
          ),
        ),
      ],
    );
  }
}
