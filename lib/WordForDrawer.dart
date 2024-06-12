import 'package:flutter/material.dart';

class WordForDrawer extends StatelessWidget {
  var singleValue;
  WordForDrawer(this.singleValue);

  @override
  Widget build(BuildContext context) {
    return Container(
      //# THis is the text displayed for drawer.
      width: 300,
      padding: const EdgeInsets.all(10),
      color: Colors.pink,
      child: Text(singleValue.toString()),
    );
  }
}
