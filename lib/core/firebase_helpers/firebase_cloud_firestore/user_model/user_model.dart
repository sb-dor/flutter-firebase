import 'package:uuid/uuid.dart';

class UserModel {
  final String id;
  final String name;
  final int age;

  UserModel({required this.name, required this.age, required this.id});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      age: json['age'],
      id: json['id'],
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
