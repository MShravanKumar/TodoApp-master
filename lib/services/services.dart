import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/model/todo_model.dart';

class Services {
  /// create
  Future addPersonalTask(Todo model, String id) async {
    return FirebaseFirestore.instance.collection("todoApp").doc(id).set(model.toMap());
  }

//update
  void update(String id, String text) async {
    return await FirebaseFirestore.instance.collection("todoApp").doc(id).update({"title": text});
  }

  ///delete
  void delete(String id) async {
    return await FirebaseFirestore.instance.collection("todoApp").doc(id).delete();
  }

  //read

  Future<Stream<QuerySnapshot>> getTask() async {
    return await FirebaseFirestore.instance.collection("todoApp").snapshots();
  }
}
