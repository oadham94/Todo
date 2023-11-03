import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/model/task_model.dart';
import '../../pages/home_layout/converted_time.dart';

class FireStoreUtilities {
  static CollectionReference<TaskModel> getCollection() {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var collectionRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("task");
    return collectionRef.withConverter<TaskModel>(
      fromFirestore: (snapshot, _) {
        return TaskModel.fromFireStore(snapshot.data()!);
      },
      toFirestore: (value, _) {
        return value.toFireStore();
      },
    );
  }

  static Future<void> addData(TaskModel taskModel) async {
    var collectionRef = getCollection();
    var docRef = collectionRef.doc();
    taskModel.id = docRef.id;
    return await docRef.set(taskModel);
  }

  static Future<void> deleteData(TaskModel task) async {
    var docRef = getCollection().doc(task.id);
    return await docRef.delete();
  }

  static Future<void> updateData(TaskModel task) async {
    getCollection().doc(task.id).update(task.toFireStore());
  }

  static Stream<QuerySnapshot<TaskModel>> getDataRealTime(DateTime time) {
    var snapshotsRef = getCollection()
        .where('dateTime',
            isEqualTo: ConvertedTime.getDate(time).millisecondsSinceEpoch)
        .snapshots();
    return snapshotsRef;
  }

  static Future<void> clickOnDone(TaskModel task) async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("task")
        .doc(task.id)
        .set(task.toFireStore());
  }
}
