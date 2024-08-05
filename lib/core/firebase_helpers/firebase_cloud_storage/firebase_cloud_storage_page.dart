import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_cloud_storage/firebase_cloud_storage_helper.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class FirebaseCloudStoragePage extends StatefulWidget {
  const FirebaseCloudStoragePage({super.key});

  @override
  State<FirebaseCloudStoragePage> createState() => _FirebaseCloudStoragePageState();
}

class _FirebaseCloudStoragePageState extends State<FirebaseCloudStoragePage> {
  final ImagePicker _imagePicker = ImagePicker();

  late FirebaseCloudStorageHelper _firebaseCloudStorageHelper;

  List<Reference> listOfFiles = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _firebaseCloudStorageHelper = getit<FirebaseCloudStorageHelper>();
    getFiles();
  }

  void getFiles() async {
    loading = true;
    setState(() {});
    listOfFiles = await _firebaseCloudStorageHelper.getFiles(
      userId: 1, // temp id
    );
    loading = false;
    setState(() {});
  }

  List<Stream<TaskSnapshot>> subs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase cloud storage page"),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async => getFiles(),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () async {
                final file = await _imagePicker.pickMedia();
                if (file == null) return;
                Stream<TaskSnapshot> stream = _firebaseCloudStorageHelper.addImage(
                  file: file,
                  userId: 1, // temp id
                );
                subs.add(stream);
                setState(() {});
                //
              },
              child: const Icon(
                Icons.get_app,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: subs.length,
              itemBuilder: (context, index) {
                final item = subs[index];
                return StreamBuilder(
                  stream: item,
                  builder: (context, snap) {
                    switch (snap.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final req = snap.requireData;
                        return Center(
                          child: CircularProgressIndicator(
                            value: req.bytesTransferred / req.totalBytes,
                          ),
                        );
                    }
                  },
                );
              },
            ),
            ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listOfFiles.length,
              itemBuilder: (context, index) {
                final item = listOfFiles[index];
                // in order to get image there is method called: "getDownloadURL()"
                // with you can either download or show image.
                // there are also another methods which call:

                // getData() -> for getting Uint8List

                // and

                // getFullMetadata()

                // File metadata contains common properties such as name, size, and contentType
                // (often referred to as MIME type) in addition to some less common ones like contentDisposition
                // and timeCreated. This metadata can be retrieved from a Cloud Storage reference using the
                // getMetadata() method.
                return FutureBuilder<String>(
                  future: item.getDownloadURL(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snap.hasError) {
                      return Text("Error: ${snap.error}");
                    } else if (snap.hasData) {
                      if (snap.requireData.contains(".mp4")) {
                        return _VideoFileWidget(path: snap.requireData);
                      } else {
                        return GestureDetector(
                          onTap: () {
                            _firebaseCloudStorageHelper.saveFile(item, snap.requireData);
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                width: 200,
                                height: 200,
                                child: Image.network(
                                  snap.requireData,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await _firebaseCloudStorageHelper.deleteFile(item);
                                  getFiles();
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      return const Text("Error occured");
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoFileWidget extends StatefulWidget {
  final String path;

  const _VideoFileWidget({
    super.key,
    required this.path,
  });

  @override
  State<_VideoFileWidget> createState() => _VideoFileWidgetState();
}

class _VideoFileWidgetState extends State<_VideoFileWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.path),
    )
      ..initialize().then(((e) => setState(() {})))
      ..play();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 200,
      // height: 200,
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : const SizedBox(),
    );
  }
}
