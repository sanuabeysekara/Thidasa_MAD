// To parse this JSON data, do
//
//     final itemModel = itemModelFromJson(jsonString);

import 'dart:convert';

ItemModel? itemModelFromJson(String str) => ItemModel.fromJson(json.decode(str));

String itemModelToJson(ItemModel? data) => json.encode(data!.toJson());

class ItemModel {
  ItemModel({
    this.cid,
    this.title,
    this.description,
    this.type,
    this.genres,
    this.age,
    this.coverPhoto,
    this.basePhoto,
    this.bannerPhoto,
    this.duration,
    this.quality,
    this.status,
    this.views,
    this.rating,
    this.comments,
    this.releasedYear,
    this.dateAdded,
    this.link,
    this.trailer,
  });

  String? cid;
  String? title;
  String? description;
  String? type;
  String? genres;
  String? age;
  String? coverPhoto;
  String? basePhoto;
  String? bannerPhoto;
  String? duration;
  String? quality;
  String? status;
  String? views;
  String? rating;
  String? comments;
  String? releasedYear;
  DateTime? dateAdded;
  dynamic link;
  String? trailer;

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
    cid: json["cid"],
    title: json["title"],
    description: json["description"],
    type: json["type"],
    genres: json["genres"],
    age: json["age"],
    coverPhoto: json["cover_photo"],
    basePhoto: json["base_photo"],
    bannerPhoto: json["banner_photo"],
    duration: json["duration"],
    quality: json["quality"],
    status: json["status"],
    views: json["views"],
    rating: json["rating"],
    comments: json["comments"],
    releasedYear: json["released_year"],
    dateAdded: DateTime.parse(json["date_added"]),
    link: json["link"],
    trailer: json["trailer"],
  );

  Map<String, dynamic> toJson() => {
    "cid": cid,
    "title": title,
    "description": description,
    "type": type,
    "genres": genres,
    "age": age,
    "cover_photo": coverPhoto,
    "base_photo": basePhoto,
    "banner_photo": bannerPhoto,
    "duration": duration,
    "quality": quality,
    "status": status,
    "views": views,
    "rating": rating,
    "comments": comments,
    "released_year": releasedYear,
    "date_added": dateAdded?.toIso8601String(),
    "link": link,
    "trailer": trailer,
  };
}
