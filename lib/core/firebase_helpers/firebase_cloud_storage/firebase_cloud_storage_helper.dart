import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
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

  // after adding image get the stream or do your own logic in order to work
  // with sending bytes for showing circular progress indicator
  // for more info check out this link:
  // https://firebase.flutter.dev/docs/storage/upload-files#monitor-upload-progress
  Stream<TaskSnapshot> addImage({
    required XFile file,
    required int userId,
  }) async* {
    final imageRef = storageRef.child(
      'images/$userId/${basenameWithoutExtension(file.path)}${extension(file.path)}',
    );
    yield* imageRef.putFile(File(file.path)).snapshotEvents;
  }

  //

  Future<void> saveFile(Reference item, String path) async {
    // first get permission for saving data
    // i didn't write it but you can find that from yahay or ftube project
    final downloadsDir = (await DownloadsPath.downloadsDirectory())?.path;
    final pathForD = "$downloadsDir/${basenameWithoutExtension(path)}${extension(path)}";
    final file = File(pathForD);
    await item.writeToFile(file);
    debugPrint("image saved");
  }

  Future<void> deleteFile(Reference ref) async {
    await ref.delete();
  }

// File metadata contains common properties such as name, size, and contentType
// (often referred to as MIME type) in addition to some less common ones like contentDisposition
// and timeCreated. This metadata can be retrieved from a Cloud Storage reference using the
// getMetadata() method.
}
