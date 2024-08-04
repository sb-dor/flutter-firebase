import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_cloud_firestore/user_model/user_model.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_cloud_firestore/user_model/user_todo.dart';

class FirebaseCloudFireStoreHelper {
  // by default you can register your app like
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // but when you want to register app in other firebase app
  // do this
  // late FirebaseFirestore _firestore;

  FirebaseFirestore get firestore => _firestore;

// if you want to register to another firebase app
// you don't have to do this
// Future<void> initFirestore() async {
// FirebaseApp secondaryApp = Firebase.app("SECOND_FIREBASE_APP"); // any other firebase app
// _firestore = FirebaseFirestore.instanceFor(app: secondaryApp);
// }

  Future<void> addUser(UserModel user) async {
    await _firestore
        .collection('users')
        .add(user.toJson())
        .then((value) => debugPrint("User Added"))
        .catchError((error) => debugPrint("Failed to add user: $error"));
  }

  Future<List<UserModel>> getUsers() async {
    return _firestore.collection('users').get().then((e) {
      return e.docs.map((user) {
        debugPrint("data: ${user.data()}");
        return UserModel.fromJson(user.data());
      }).toList();
    });
  }

  Future<List<UserTodo>> usersTodos(UserModel user) async {
    return _firestore.collection('users_todo').where('user_id', isEqualTo: user.id).get().then((e) {
      return e.docs.map((e) {
        return UserTodo.fromJson(e.data());
      }).toList();
    });
  }

  Future<void> addTodo(UserTodo todo) async {
    await _firestore.collection('users_todo').add(todo.toJson());
  }
}
