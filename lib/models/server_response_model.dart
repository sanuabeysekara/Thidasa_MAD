// To parse this JSON data, do
//
//     final serverResponse = serverResponseFromJson(jsonString);

import 'dart:convert';

ServerResponse? serverResponseFromJson(String str) => ServerResponse.fromJson(json.decode(str));

String serverResponseToJson(ServerResponse? data) => json.encode(data!.toJson());

class ServerResponse {
  ServerResponse({
    this.code,
    this.message,
  });

  int? code;
  String? message;

  factory ServerResponse.fromJson(Map<String, dynamic> json) => ServerResponse(
    code: json["code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
  };
}