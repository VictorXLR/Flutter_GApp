import "package:flutter/material.dart";
import 'package:chat/Record.dart';

class InputWidget extends StatefulWidget {
  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final myController = TextEditingController();

  var newValueText = Text("New Value", style: TextStyle(fontSize: 20.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(padding: const EdgeInsets.all(16.0), children: <Widget>[
        newValueText,
        TextField(
          controller: myController,
          autofocus: false,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () {
              String name = myController.text;
              reactBtnPress(name);
            },
            child: Text("Submit"),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              print("Clear all Trash Button");
              deleteAllTrash();
            },
            child: Text("Clear Trash")),
      ]),
    );
  }

  void reactBtnPress(name) {
    if (name.isNotEmpty) {
      checkRecord(name).then((value) {
        if (value)
          addRecord(name);
        else {
          Scaffold.of(context).showSnackBar(snackBar(name));
        }
      });
    }
  }
}

Widget snackBar(String name) {
  return SnackBar(content: Text("$name value already exists"));
}
