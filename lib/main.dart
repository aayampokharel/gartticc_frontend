//#c5c5c5 (background colorof the speed clockimage ) is the required color theme here . i am going to create some old magic thing here.
//@ for background
/// #C4C3C4
////use this as white background color ,
//? #100F10 is black color to be used . use it as theme.
// //#5E5C5D use this as another gray color .
//!https://coolors.co/5e5c5d-c4c3c4-c2c0c2-100f10-c4c1c3

import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:x/MyApp.dart';
import 'package:x/painter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApps());
}

class MyApps extends StatelessWidget {
  const MyApps({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffc5c5c5))),
      home: Name(),
    );
  }
}

class Name extends StatefulWidget {
  const Name({super.key});

  @override
  State<Name> createState() => _NameState();
}

var singleValue;
var listOfName = [];

class _NameState extends State<Name> {
  TextEditingController loginController = TextEditingController();
  //
  //
  //? getkustofwords() returns a single word from backend in thee break section in painter
  Future getListOfWords() async {
    var response = await http.get(Uri.parse(
        "http://localhost:8080/listofwords")); //! not list of word but the neext word in queue from backend
    return response.body;
  }

  //
  //
  //? end

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffc5c5c5),
      appBar: AppBar(
        title: const Text("keep your name"),
      ),
      body: Column(
        children: [
          TextField(
            controller: loginController, //@ this is useful for login with name
            onSubmitted: (t) {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MyApp(loginController.text, getListOfWords);
              }));
            },
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MyApp(loginController.text, getListOfWords);
                }));
              },
              child: const Text("Ok")),
        ],
      ),
    );
  }
}
