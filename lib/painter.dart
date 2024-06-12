import 'dart:async';
import 'dart:convert';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:x/Canvas/AniBar.dart';
import 'package:x/Canvas/AnimationService.dart';
import 'package:x/Canvas/drawer.dart';

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
            singleValue; //! this is causing the initial rebuild of widget which is not good dbecause of setstate. or its another issue. but 500ms bhitra there is setstate running .
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
                Container(
                  //# THis is the text displayed for drawer.
                  width: 300,
                  padding: const EdgeInsets.all(10),
                  color: Colors.pink,
                  child: Text(singleValue.toString()),
                ),
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
            return Container(
              color: Colors.red,
              child: const Text("take a break guys...... "),
            );

            /// below code is for display of drawn elements.
          } else {
            //@ THIS is called for non-drawers ones.
            widget.localStreamForTextField(false);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                    future: forProgressBar.forProgressBar(),
                    builder: (context, fsnapshot) {
                      if (fsnapshot.hasData) {
                        if (!toogleValueForProgressBar) {
                          toogleValueForProgressBar = true;
                          var responseDoubleTime =
                              double.parse(fsnapshot.data!) * 1000 + 600;
                          responseDoubleTime = responseDoubleTime >= 19600
                              ? 19000
                              : responseDoubleTime;

                          return TweenAnimationBuilder(
                            duration: Duration(
                                milliseconds: 19600 -
                                    int.parse(responseDoubleTime.toString())),
                            tween: Tween<double>(
                                begin: (responseDoubleTime / 1000) *
                                    15, // iineach second 15 15 ko rate le bhyauna parcha animatiioin.
                                end: 300),
                            builder: (BuildContext context, dynamic value,
                                Widget? child) {
                              return Container(
                                height: 20,
                                width: value,
                                color: Colors.deepOrange,
                              );
                            },
                          );
                        } else {
                          return TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 19600),
                            tween: Tween<double>(begin: 0, end: 300),
                            builder: (BuildContext context, dynamic value,
                                Widget? child) {
                              return Container(
                                height: 20,
                                width: value,
                                color: Colors.deepOrange,
                              );
                            },
                          );
                        }
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
                StreamBuilder(
                    stream: paintStream,
                    builder: (context, snapshots) {
                      paintStreamUse(guesserController, snapshots);

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
