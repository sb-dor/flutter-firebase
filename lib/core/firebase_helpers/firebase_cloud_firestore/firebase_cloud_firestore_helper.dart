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

  Future<void> initFirestore() async {
    // if you want to register to another firebase app
    // you don't have to do this
    // FirebaseApp secondaryApp = Firebase.app("SECOND_FIREBASE_APP"); // any other firebase app
    // _firestore = FirebaseFirestore.instanceFor(app: secondaryApp);

    //
    //
    // Firestore provides out of the box support for offline capabilities. When reading and writing
    // data, Firestore uses a local database which automatically synchronizes with the server. Cloud
    // Firestore functionality continues when users are offline, and automatically handles data migration when they regain connectivity.
    //
    // This functionality is enabled by default, however it can be disabled if needed. The settings
    // must be set before any Firestore interaction is performed:
    //
    FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
  }

  Future<void> addUser(UserModel user) async {
    await _firestore
        .collection('users')
        .add(user.toJson())
        .then((value) => debugPrint("User Added"))
        .catchError((error) => debugPrint("Failed to add user: $error"));
  }

  Future<void> updatedUser(UserModel user) async {
    await _firestore.collection('users').doc(user.documentId).update(
          user.toJson(),
        );
  }

  // Firestore lets you execute multiple write operations as a single batch that can contain any
  // combination of set, update, or delete operations.
  Future<void> deleteUser(UserModel user) async {
    WriteBatch batch = _firestore.batch();

    // get all another user's data
    // it gives list of <QuerySnapshot>
    QuerySnapshot usersTodoSnapshot =
        await _firestore.collection('users_todo').where('user_id', isEqualTo: user.id).get();

    // iterate over each document and add delete operation to the batch
    for (QueryDocumentSnapshot doc in usersTodoSnapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();

    await _firestore.collection('users').doc(user.documentId).delete();
  }

  Future<List<UserModel>> getUsers() async {


    return _firestore.collection('users').get().then(
      (e) {
        return e.docs.map(
          (user) {
            return UserModel.fromJson(
              user.data(),
              documentId: user.id,
            );
          },
        ).toList();
      },
    );
  }

  Future<List<UserTodo>> usersTodos(UserModel user) async {
    return _firestore.collection('users_todo').where('user_id', isEqualTo: user.id).get().then(
      (e) {
        return e.docs.map(
          (e) {
            return UserTodo.fromJson(
              e.data(),
              documentId: e.id,
            );
          },
        ).toList();
      },
    );
  }

  Future<void> addTodo(UserTodo todo) async {
    await _firestore.collection('users_todo').add(todo.toJson());
  }
}
