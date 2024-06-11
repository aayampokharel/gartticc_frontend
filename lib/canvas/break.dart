import 'dart:convert';

import 'package:flutter/material.dart';

class breakContainer extends StatelessWidget {
  String singleValue;
  //Future Function() getListOfWords;
  //void Function() setSingleValueWhenBreak;

  breakContainer(this.singleValue);

  @override
  Widget build(BuildContext context) {
    //! this is for not letting yellow player to write. working ...feri kina rewrite bhayo bhanda cause this painter is inside the streambuilder and already said its like server and setstate waiting for data and rebuilding the thing . so painter lai bahira pathaune from main.

    return Container(
      color: Colors.red,
      child: const Text("take a break guys...... "),
    );

    /// below code is for display of drawn elements.
  }
}
