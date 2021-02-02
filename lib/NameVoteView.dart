import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:chat/Record.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Baby Name Votes")),
      body: buildBody(context),
    );
  }
}

Widget buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("baby").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.docs);
      });
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final record = Record.fromSnapshot(data);

  return Dismissible(
      child: Padding(
        key: ValueKey(record.name),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: _listTileItem(context, record),
      ),
      key: Key(record.name),
      onDismissed: (direction) {
        print(direction);

        deleteRecord(record.name);

        Scaffold.of(context).showSnackBar(snackBar(record.name));
      },
      background: Container(color: Colors.red));
}

Widget _listTileItem(BuildContext context, Record record) {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0)),
    child: ListTile(
      title: Text(record.name),
      trailing: Text(record.votes.toString()),
      onTap: () => record.reference.update({"votes": FieldValue.increment(1)}),
    ),
  );
}

Widget snackBar(String name) {
  return SnackBar(
    content: Text("$name deleted"),

  );
}
