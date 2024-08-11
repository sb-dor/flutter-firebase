import 'package:uuid/uuid.dart';

class FirebaseRTDUser {
  final String? remoteId;
  final String id;
  final String name;
  final int age;
  String? message;
  final String? dateTime;

  FirebaseRTDUser({
    this.remoteId,
    required this.name,
    required this.age,
    this.message,
    this.dateTime,
  }) : id = const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "age": age,
      "message": message,
      "date_time": DateTime.now().toString().substring(0, 19)
    };
  }

  factory FirebaseRTDUser.fromJson(Map<Object?, Object?> json, {String? remoteId}) {
    return FirebaseRTDUser(
      name: json['name'] as String,
      age: json['age'] as int,
      message: json['message'] as String?,
      remoteId: remoteId,
      dateTime: json['date_time'] as String?,
    );
  }
}
