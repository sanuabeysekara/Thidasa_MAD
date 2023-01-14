import 'dart:convert';


class User {
  User({
    this.uid,
    this.su,
    this.name,
    this.email,
    this.password,
    this.verifyCode,
    this.registeredDate,
    this.userStatus,
    this.comments,
    this.reviews,
  });

  String? uid;
  String? su;
  String? name;
  String? email;
  String? password;
  String? verifyCode;
  DateTime? registeredDate;
  String? userStatus;
  String? comments;
  String? reviews;

  factory User.fromJson(Map<String, dynamic> json) => User(
    uid: json["uid"],
    su: json["su"],
    name: json["name"],
    email: json["email"],
    password: json["password"],
    verifyCode: json["verify_code"],
    registeredDate: DateTime.parse(json["registered_date"]),
    userStatus: json["user_status"],
    comments: json["comments"],
    reviews: json["reviews"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "su": su,
    "name": name,
    "email": email,
    "password": password,
    "verify_code": verifyCode,
    "registered_date": registeredDate?.toIso8601String(),
    "user_status": userStatus,
    "comments": comments,
    "reviews": reviews,
  };
}
