import 'dart:async';

import 'package:flutter/material.dart';

class BoolStream {
  StreamController<bool> boolStreamController;
  BoolStream() : boolStreamController = StreamController.broadcast();

  void add(bool val) {
    boolStreamController.add(val);
  }

  Stream<bool> get stream => boolStreamController
      .stream; //#get ma no () reqd as in function . tyo faida.

  void close() {
    boolStreamController.close();
  }
}
