import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class FirebaseCloudStorageHelper {
  final FirebaseStorage _firebaseStorageRef = FirebaseStorage.instance;

  late Reference storageRef;

  Future<void> init() async {
    storageRef = _firebaseStorageRef.ref();
  }

  Future<List<Reference>> getFiles({required int userId}) async {
    final files = await storageRef.child('images/$userId').listAll();
    debugPrint("files length is: ${files.items.length}");
    return files.items;
  }

  Future<void> addImage({
    required XFile file,
    required int userId,
  }) async {
    final imageRef = storageRef.child(
      'images/$userId/${basenameWithoutExtension(file.path)}${extension(file.path)}',
    );
    await imageRef.putFile(File(file.path));
  }
}
