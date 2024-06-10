import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:x/MyApp.dart';
import 'package:x/painter.dart';
import 'package:http/http.dart' as http;

class BodyFuture extends StatefulWidget {
  dynamic responses;
  String currentTurn;
  dynamic messageStream;
  List<dynamic> listOfMessage;
  StreamController<bool> boolStreamController;
  TextEditingController chatController;
  var insideOnPressed; ////this might give error while running .
  var localStreamForTextField;

  String currentName;

  Future<dynamic> Function() getListOfWords;
  BodyFuture(
      this.currentName,
      this.getListOfWords,
      this.responses,
      this.currentTurn,
      this.messageStream,
      this.listOfMessage,
      this.boolStreamController,
      this.chatController,
      this.insideOnPressed,
      this.localStreamForTextField);

  @override
  State<BodyFuture> createState() => _BodyFutureState();
}

class _BodyFutureState extends State<BodyFuture> {
  @override
  Widget build(BuildContext context) {
    return
  }
}
