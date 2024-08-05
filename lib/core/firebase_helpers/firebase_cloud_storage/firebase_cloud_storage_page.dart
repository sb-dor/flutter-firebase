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
                await _firebaseCloudStorageHelper.addImage(
                  file: file,
                  userId: 1, // temp id
                );
                getFiles();
              },
              child: const Icon(
                Icons.get_app,
              ),
            ),
            ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listOfFiles.length,
              itemBuilder: (context, index) {
                final item = listOfFiles[index];
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
                        return SizedBox(
                          width: 200,
                          height: 200,
                          child: Image.network(
                            snap.requireData,
                            fit: BoxFit.cover,
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
