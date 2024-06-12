import 'dart:async';
import 'dart:convert';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter/material.dart';
import 'package:x/Canvas/AniBar.dart';
import 'package:x/Canvas/AnimationService.dart';
import 'package:x/Canvas/break.dart';
import 'package:x/Canvas/drawer.dart';
import 'package:x/Canvas/guesser.dart';
import 'package:x/Canvas/guesserAniBar.dart';
import 'package:x/WordForDrawer.dart';
import 'package:x/logic/checkChannel.dart';
import 'package:x/logic/drawingController.dart';
import 'package:x/logic/paintChannel.dart';
import 'package:x/main.dart';

class Painter extends StatefulWidget {
  @override
  State<Painter> createState() => _PainterState();
  String currentName;
  String currentTurn;
  Function(bool) localStreamForTextField;
  Future Function() getListOfWords;

  Painter(this.currentName, this.currentTurn, this.localStreamForTextField,
      this.getListOfWords,
      {super.key});
}

class _PainterState extends State<Painter> {
  var localName;
  DrawingController guesserController = DrawingController();

//@ alertWebsocket() is for adding true so that the input field is readonly:true

  var paintStream;
  var checkStream;

  var toogleValueForProgressBar = false;

  AnimationService forProgressBar = AnimationService();

  @override
  void initState() {
    //@ alertWebsocket() is called to make input field is readonly while player is drawing
    super.initState();

    widget.getListOfWords().then((value) {
      setState(() {
        singleValue = jsonDecode(value).toString();
        localName =
            singleValue; //! this is causing the initial rebuild of widget which is not good dbecause of setstate. or its another issue. but 500ms bhitra there is setstate running .ELSE USE CIRCULAR PROGRESS INDICATOR.
      });
    });

    if (widget.currentName == widget.currentTurn) {
      checkChannel.alertWebSocket();
    }
    paintStream = paintChannel.broadcastStream();
    checkStream = checkChannel
        .broadcastStream(); //@ this makes other things depend on it .
  }

  final DrawingController drawingController = DrawingController();
  final paintChannel = PaintChannel();

  final checkChannel = CheckChannel();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: checkStream,

        /// this is for checking if the turn is this particular user or not
        builder: (context, snapshott) {
          drawingController.clear();
          guesserController.clear();
          singleValue = localName;
          if (snapshott.data == widget.currentName) {
            widget.localStreamForTextField(true);

            ///again setting readonly for the input field for drawer
          }
          if (snapshott.data == widget.currentName && snapshott.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                animationBar(),
                WordForDrawer(singleValue),
                Drawing(paintChannel, drawingController),
              ],
            );

            ///break is the data sent in the stream after a certain time for drawer to change the drawing power to someone else.
          } else if ((snapshott.data.toString() == "Break")) {
            singleValue = "";

            //! this is for not letting yellow player to write. working ...feri kina rewrite bhayo bhanda cause this painter is inside the streambuilder and already said its like server and setstate waiting for data and rebuilding the thing . so painter lai bahira pathaune from main.

            widget.getListOfWords().then((value) {
              localName = jsonDecode(value).toString();
            });

            toogleValueForProgressBar = true;
            return const BreakContainer();

            /// below code is for display of drawn elements.
          } else {
            //@ THIS is called for non-drawers ones.
            widget.localStreamForTextField(false);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GuesserAnimationBar(
                  //can combine this with above animation one with new parameter .
                  toogleValueForProgressBar,
                  forProgressBar,
                ),
                StreamBuilder(
                    stream: paintStream,
                    builder: (context, snapshots) {
                      paintStreamUse(guesserController, snapshots);

                      return guesserContainer(guesserController);
                    }),
              ],
            );
          }
        });
  }

  @override
  void dispose() {
    // Close the WebSocket channels
    paintChannel.close();
    paintChannel.drain();
    checkChannel.close();
    checkChannel.drain();

    // Dispose the drawing controllers
    drawingController.dispose();
    guesserController.dispose();

    // Close the streams if they have subscriptions
    if (paintStream is StreamSubscription) {
      paintStream.cancel();
    }
    if (checkStream is StreamSubscription) {
      checkStream.cancel();
    }

    super.dispose();
  }
}
