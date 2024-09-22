
class UserTodo {
  final String userId;
  final String textTodo;
  final String id;
  final String? documentId;

  UserTodo(
    this.userId,
    this.textTodo,
    this.id, {
    this.documentId,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "text_todo": textTodo,
    };
  }

  factory UserTodo.fromJson(
    Map<String, dynamic> json, {
    String? documentId,
  }) {
    return UserTodo(
      json['user_id'],
      json['text_todo'],
      json['id'],
      documentId: documentId,
    );
  }
}
