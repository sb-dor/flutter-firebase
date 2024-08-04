import 'package:flutter/cupertino.dart';

class UserModel {
  final String id;
   String name;
  final int age;
  final String? documentId;

  bool update = false;
  final TextEditingController textEditingController = TextEditingController();

  UserModel({
    required this.name,
    required this.age,
    required this.id,
    this.documentId,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json, {
    String? documentId,
  }) {
    return UserModel(
      name: json['name'],
      age: json['age'],
      id: json['id'],
      documentId: documentId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "age": age,
    };
  }
}
