import 'dart:convert';

import 'package:get/get.dart';
import 'package:news/models/user_model.dart';

Token? tokenFromJson(String str) => Token.fromJson(json.decode(str));

String tokenToJson(Token? data) => json.encode(data!.toJson());

class Token {
  Token({
    this.status,
    this.user,
    this.token,
  });

  String? status;
  User? user;
  String? token;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    status: json["status"],
    user: json["user"]==""?User():User.fromJson(json["user"]!),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "user": user!.toJson(),
    "token": token,
  };
}