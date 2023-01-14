import 'dart:convert';

class Review {
  Review({
    this.rid,
    this.cid,
    this.title,
    this.description,
    this.rating,
    this.dateTime,
    this.userAdded,
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

  String? rid;
  String? cid;
  String? title;
  String? description;
  String? rating;
  DateTime? dateTime;
  String? userAdded;
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

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    rid: json["rid"],
    cid: json["cid"],
    title: json["title"],
    description: json["description"],
    rating: json["rating"],
    dateTime: DateTime.parse(json["date_time"]),
    userAdded: json["user_added"],
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
    "rid": rid,
    "cid": cid,
    "title": title,
    "description": description,
    "rating": rating,
    "date_time": dateTime?.toIso8601String(),
    "user_added": userAdded,
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
