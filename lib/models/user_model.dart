// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.validationErrors,
    required this.hasError,
    required this.message,
    required this.data,
  });

  List<dynamic> validationErrors;
  bool hasError;
  dynamic message;
  List<Datum> data;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        validationErrors:
            List<dynamic>.from(json["ValidationErrors"].map((x) => x)),
        hasError: json["HasError"],
        message: json["Message"],
        data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ValidationErrors": List<dynamic>.from(validationErrors.map((x) => x)),
        "HasError": hasError,
        "Message": message,
        "Data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    required this.birthDate,
    required this.profilePhoto,
    required this.friendIds,
  });

  String id;
  String firstName;
  String lastName;
  String fullName;
  String email;
  DateTime birthDate;
  String profilePhoto;
  List<dynamic> friendIds;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["Id"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        fullName: json["FullName"],
        email: json["Email"],
        birthDate: DateTime.parse(json["BirthDate"]),
        profilePhoto: json["ProfilePhoto"],
        friendIds: List<dynamic>.from(json["FriendIds"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "FirstName": firstName,
        "LastName": lastName,
        "FullName": fullName,
        "Email": email,
        "BirthDate": birthDate.toIso8601String(),
        "ProfilePhoto": profilePhoto,
        "FriendIds": List<dynamic>.from(friendIds.map((x) => x)),
      };
}
