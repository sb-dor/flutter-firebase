import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_cloud_firestore/firebase_cloud_firestore_helper.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_cloud_firestore/user_model/user_model.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_cloud_firestore/user_model/user_todo.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';
import 'package:uuid/uuid.dart';

class FirebaseCloudFirestorePage extends StatefulWidget {
  const FirebaseCloudFirestorePage({super.key});

  @override
  State<FirebaseCloudFirestorePage> createState() => _FirebaseCloudFirestorePageState();
}

class _FirebaseCloudFirestorePageState extends State<FirebaseCloudFirestorePage> {
  List<UserModel> userModels = [];

  bool loading = false;

  Future<void> getUsers() async {
    loading = true;
    setState(() {});
    userModels.clear();
    userModels = await getit<FirebaseCloudFireStoreHelper>().getUsersWithRef();
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUsers();

    Connectivity connectivity = Connectivity();

    connectivity.onConnectivityChanged.listen((e) async {
      if (e.contains(ConnectivityResult.wifi) || e.contains(ConnectivityResult.mobile)) {
        await getit<FirebaseCloudFireStoreHelper>().firestore.enableNetwork();
      } else {
        await getit<FirebaseCloudFireStoreHelper>().firestore.disableNetwork();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase cloud firebase"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const _AddUserPage(),
            ),
          );
          await getUsers();
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => getUsers(),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  ListView.builder(
                    itemCount: userModels.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final user = userModels[index];
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => _UsersTodo(userModel: user),
                            ),
                          );
                        },
                        title: user.update
                            ? TextField(
                                controller: user.textEditingController,
                              )
                            : Text("${index + 1}) Name: ${user.name}"),
                        subtitle: Text("Age: ${user.age}"),
                        leading: IconButton(
                          onPressed: () async {
                            user.update = !user.update;
                            setState(() {});
                            if (user.update) {
                              user.textEditingController.text = user.name;
                            } else {
                              user.name = user.textEditingController.text.trim();
                              await getit<FirebaseCloudFireStoreHelper>().updatedUserWithRef(user);
                            }
                            setState(() {});
                          },
                          icon: Icon(
                            user.update ? Icons.save : Icons.edit,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            await getit<FirebaseCloudFireStoreHelper>().deleteUserWithRef(user);
                            await getUsers();
                          },
                          icon: const Icon(
                            Icons.delete,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

class _AddUserPage extends StatefulWidget {
  const _AddUserPage({super.key});

  @override
  State<_AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<_AddUserPage> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add User"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final user = UserModel(
            name: _nameController.text.trim(),
            age: int.tryParse(_ageController.text.trim()) ?? 0,
            id: const Uuid().v4(),
          );
          await getit<FirebaseCloudFireStoreHelper>().addUserWithRef(user);
          if (context.mounted) Navigator.pop(context);
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: "User name",
            ),
          ),
          TextField(
            controller: _ageController,
            decoration: const InputDecoration(
              hintText: "User age",
            ),
          ),
        ],
      ),
    );
  }
}

class _UsersTodo extends StatefulWidget {
  final UserModel userModel;

  const _UsersTodo({
    super.key,
    required this.userModel,
  });

  @override
  State<_UsersTodo> createState() => _UsersTodoState();
}

class _UsersTodoState extends State<_UsersTodo> {
  List<UserTodo> userTodo = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    loading = true;
    setState(() {});

    userTodo = await getit<FirebaseCloudFireStoreHelper>().usersTodosWithRef(widget.userModel);

    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final UserTodo todo = UserTodo(
            widget.userModel.id,
            Faker().lorem.sentence(),
            const Uuid().v4(),
          );

          await getit<FirebaseCloudFireStoreHelper>().addTodoWithRef(todo);
          getData();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          widget.userModel.name,
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => getData(),
              child: ListView(
                children: [
                  ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: userTodo.length,
                    itemBuilder: (context, index) {
                      final todo = userTodo[index];
                      return ListTile(
                        title: Text(todo.textTodo),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
