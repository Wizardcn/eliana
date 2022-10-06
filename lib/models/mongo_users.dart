// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

// ignore_for_file: prefer_if_null_operators

import 'dart:convert';

MongoUser userFromJson(String str) => MongoUser.fromJson(json.decode(str));

String userToJson(MongoUser data) => json.encode(data.toJson());

class MongoUser {
  String uid;
  String username;
  String email;
  int totalPoint;
  String profilePicUrl;
  RecordHistory recordHistory;

  MongoUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.totalPoint,
    required this.profilePicUrl,
    required this.recordHistory,
  });

  factory MongoUser.fromJson(Map<String, dynamic> json) => MongoUser(
        uid: json["uid"],
        username: json["username"],
        email: json["email"],
        totalPoint: json["total_point"],
        profilePicUrl: json["profile_pic_url"],
        recordHistory: RecordHistory.fromJson(json["record_history"]),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "email": email,
        "total_point": totalPoint,
        "profile_pic_url": profilePicUrl,
        "record_history": recordHistory.toJson(),
      };
}

class RecordHistory {
  RecordHistory();

  factory RecordHistory.fromJson(Map<String, dynamic> json) => RecordHistory();

  Map<String, dynamic> toJson() => {};
}
