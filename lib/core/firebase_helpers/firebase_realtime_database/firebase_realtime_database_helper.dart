import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_realtime_database/models/chat_message.dart';

class FirebaseRealtimeDatabaseHelper {
  //
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  Stream<List<FirebaseRTDUser>> listenToData(String refPath) async* {
    DatabaseReference databaseReference = _firebaseDatabase.ref("user_chats/$refPath");

    yield* databaseReference.limitToLast(5).onValue.asyncMap(
      (e) {
        if (e.snapshot.value == null) return <FirebaseRTDUser>[];
        final Map<Object?, Object?> data =
            e.snapshot.value as Map<Object?, Object?>; // because runtime is this one
        return data.entries
            .map(
              (e) => FirebaseRTDUser.fromJson(
                e.value as Map<Object?, Object?>,
                remoteId: e.key as String,
              ),
            )
            .toList()
          ..sort(
              (a, b) => DateTime.parse(a.dateTime!).isAfter(DateTime.parse(b.dateTime!)) ? 1 : 0);
      },
    );
  }

  // the chat name can be anything
  Future<void> sendMessage(
    FirebaseRTDUser user,
    String refPath,
  ) async {
    final ref = "user_chats/$refPath";
    DatabaseReference databaseReference = _firebaseDatabase.ref(ref);

    //
    // set will replace existing data
    // await databaseReference.set(user.toJson());

    // this will create new value instead of changing data
    await databaseReference.push().set(user.toJson());
  }

  Future<void> removeAllTreeData(String refPath) async {
    DatabaseReference databaseReference = _firebaseDatabase.ref(refPath);
    await databaseReference.remove();
  }

  //
  Future<void> deleteRaw(String refPath, String rawName) async {
    DatabaseReference databaseReference = _firebaseDatabase.ref("user_chats/$refPath");
    await databaseReference.child(rawName).remove();
  }
//
}
