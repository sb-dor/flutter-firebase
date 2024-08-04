import 'package:uuid/uuid.dart';

class UserTodo {
  final String userId;
  final String textTodo;
  final String id;

  UserTodo(this.userId, this.textTodo, this.id,);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "text_todo": textTodo,
    };
  }

  factory UserTodo.fromJson(Map<String, dynamic> json) {
    return UserTodo(
      json['user_id'],
      json['text_todo'],
      json['id'],
    );
  }
}
