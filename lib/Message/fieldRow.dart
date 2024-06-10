import 'package:flutter/material.dart';

Widget fieldRow(
    AsyncSnapshot noEntrySnapshot,
    TextEditingController chatController,
    dynamic Function(String) insideOnPressed) {
  return Row(
    children: [
      Container(
        color: Colors.purple,
        width: 500,
        child: TextField(
          readOnly: noEntrySnapshot.data ?? false,
          controller: chatController,
          onSubmitted: (text) {
            if (noEntrySnapshot.data == false) {
              insideOnPressed(text);
              chatController.text = "";
            } else {
              null;
            }
          },
        ),
      ),
      ElevatedButton(
          onPressed: () {
            if (noEntrySnapshot.data == false) {
              insideOnPressed(chatController.text);
              chatController.text = "";
            } else {
              null;
            }
          },
          child: Text("OK")),
    ],
  );
}

Row onceMessageTextField(
    AsyncSnapshot<bool> initialSnapshot,
    TextEditingController chatController,
    dynamic Function(String) insideOnPressed) {
  return Row(
    children: [
      Container(
        color: Colors.brown,
        width: 500,
        child: TextField(
          readOnly: initialSnapshot.data ?? false,
          controller: chatController,
          onSubmitted: (txts) {
            // if (initialSnapshot.data == false) {
            //  print("inside brown once and false");
            insideOnPressed(chatController.text);
            chatController.text = "";
            // } else {
            //   null;
            // }
          },
        ),
      ),
      ElevatedButton(
          onPressed: () {
            if (initialSnapshot.data == false) {
              insideOnPressed(chatController.text);
              chatController.text = "";
            } else {
              null;
            }
          },
          child: const Text("OK")),
    ],
  );
}
