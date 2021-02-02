import "package:cloud_firestore/cloud_firestore.dart";

class Record {
  final String name;
  final int votes;
  final DocumentReference reference;

  // create a Record obect from a map or json object
  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['votes'] != null),
        name = map['name'],
        votes = map['votes'];

  // create a record object from a Firebase Snapshot
  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$votes>";
}

CollectionReference from = FirebaseFirestore.instance.collection("baby");
CollectionReference trash = FirebaseFirestore.instance.collection("deleted");

Future<void> addRecord(String name) async {
  return from
      .add(<String, Object>{"name": name, 'votes': 0})
      .then((value) => print("Name: $name Added"))
      .catchError((error) => print("Failed to set baby: $error"));
}

Future<bool> checkRecord(String name) async {
  return await from.where('name', isEqualTo: name).get().then((value) {
    if (value.size > 0) {
      return Future.value(false);
    } else
      return Future.value(true);
  });
}

// to delete a record we copy it from 'baby' to 'deleted' collection
// then we delete it from 'baby' collection, the aim of this is to
// allow deleted data be restored from the undo button is clicked..ww
Future<void> deleteRecord(String name) {
  return from.where('name', isEqualTo: name).get().then((value) {
    value.docs.forEach((DocumentSnapshot element) {
      print(element.data());
      print(element.id);
      moveTrash(element);
      deleteTrash(from, element);
    });
  });
}

Future<void> moveTrash(DocumentSnapshot message) {
  return trash
      .add(message.data())
      .then((value) =>
          print("Successfully added ${message.data()} to Trash Collection"))
      .catchError((error) =>
          print("Failed to copy record ${message.data()} to Trash "));
}

Future<void> deleteTrash(CollectionReference from, DocumentSnapshot element) {
  return from
      .doc(element.id)
      .delete()
      .then((value) => print("successfully deleted object"))
      .catchError((onError) => print("Failed to delete object ${element.id} "));
}

Future<void> deleteAllTrash() {
  CollectionReference trash = FirebaseFirestore.instance.collection("deleted");
  return trash.get().then((values) {
    values.docs.forEach((DocumentSnapshot element) {
      trash
          .doc(element.id)
          .delete()
          .then((value) => print("Deleted Every Record in Trash Collection"))
          .catchError(
              (onError) => print("Error Deleting all Records: $onError "));
    });
  });
}
