import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_realtime_database/firebase_realtime_database_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_realtime_database/models/chat_message.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';

class FirebaseRealtimeDatabasePage extends StatefulWidget {
  const FirebaseRealtimeDatabasePage({super.key});

  @override
  State<FirebaseRealtimeDatabasePage> createState() => _FirebaseRealtimeDatabasePageState();
}

class _FirebaseRealtimeDatabasePageState extends State<FirebaseRealtimeDatabasePage> {
  late final FirebaseRTDUser _firstUser;
  late final FirebaseRTDUser _secondUser;
  late final String refPath;

  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _secondTextEditingController = TextEditingController();

  late final FirebaseRealtimeDatabaseHelper _firebaseRealtimeDatabaseHelper;

  @override
  void initState() {
    super.initState();
    _firebaseRealtimeDatabaseHelper = getit<FirebaseRealtimeDatabaseHelper>();
    _firstUser = FirebaseRTDUser(name: "Avaz", age: 22);
    _secondUser = FirebaseRTDUser(name: "Mick", age: 25);
    refPath = "${_firstUser.id}_${_secondUser.id}";

    _firebaseRealtimeDatabaseHelper.listenToData(refPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Real-time database"),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Row(
            children: [
              Expanded(
                child: _UserTextControllerWidget(
                  firebaseRTDUser: _firstUser,
                  controller: _textEditingController,
                  refPath: refPath,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: _UserTextControllerWidget(
                  firebaseRTDUser: _secondUser,
                  controller: _secondTextEditingController,
                  refPath: refPath,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          StreamBuilder(
            stream: _firebaseRealtimeDatabaseHelper.listenToData(refPath),
            builder: (context, snap) {
              switch (snap.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snap.requireData;
                  return ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return ListTile(
                        title: Text("User: ${item.name}"),
                        subtitle: Text("Message: ${item.message}"),
                        trailing: IconButton(
                          onPressed: () async {
                            await _firebaseRealtimeDatabaseHelper.deleteRaw(
                              refPath,
                              item.remoteId ?? '',
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                          ),
                        ),
                      );
                    },
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _UserTextControllerWidget extends StatelessWidget {
  final FirebaseRTDUser firebaseRTDUser;
  final TextEditingController controller;
  final String refPath;

  const _UserTextControllerWidget({
    super.key,
    required this.firebaseRTDUser,
    required this.controller,
    required this.refPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("User: ${firebaseRTDUser.name}"),
        TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Message from: ${firebaseRTDUser.name}"),
        ),
        TextButton(
          onPressed: () async {
            getit<FirebaseRealtimeDatabaseHelper>().sendMessage(
              firebaseRTDUser..message = controller.text.trim(),
              refPath,
            );
          },
          child: const Text("Send data"),
        ),
      ],
    );
  }
}
