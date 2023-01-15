// To parse this JSON data, do
//
//     final itemModel = itemModelFromJson(jsonString);

import 'dart:convert';
final String tableSavedItems = 'saved_items_table';



class SavedItemFields{
  static final List<String> values = [
    /// Add all fields
   id,cid, title, description, type, genres, age, coverPhoto, basePhoto,bannerPhoto,duration,quality,status,
  views,rating,comments,releasedYear,dateAdded,link,trailer,offlineStatus,offlinePath
  ];

  static final String id = "id";
  static final String cid = "cid";
  static final String title = "title";
  static final String description = "description";
  static final String type = "type";
  static final String genres = "genres";
  static final String age = "age";
  static final String coverPhoto = "cover_photo";
  static final String basePhoto = "base_photo";
  static final String bannerPhoto = "banner_photo";
  static final String duration = "duration";
  static final String quality = "quality";
  static final String status = "status";
  static final String views = "views";
  static final String rating = "rating";
  static final String comments = "comments";
  static final String releasedYear = "released_year";
  static final String dateAdded = "date_added";
  static final String link = "link";
  static final String trailer = "trailer";
  static final String offlineStatus = "offline_status";
  static final String offlinePath = "offline_path";






}




SavedItemModel? itemModelFromJson(String str) => SavedItemModel.fromJson(json.decode(str));

String itemModelToJson(SavedItemModel? data) => json.encode(data!.toJson());

class SavedItemModel {
  SavedItemModel({
    this.id,
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
    this.offlineStatus,
    this.offlinePath
  });
  int? id;
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
  String? offlineStatus;
  String? offlinePath;


  SavedItemModel copyWith({
    int? id,
    String? cid,
    String? title,
    String? description,
    String? type,
    String? genres,
    String? age,
    String? coverPhoto,
    String? basePhoto,
    String? bannerPhoto,
    String? duration,
    String? quality,
    String? status,
    String? views,
    String? rating,
    String? comments,
    String? releasedYear,
    DateTime? dateAdded,
    dynamic link,
    String? trailer,
    String? offlineStatus,
    String? offlinePath,
  }) =>
      SavedItemModel(
        id: id ?? this.id,
        cid: cid ?? this.cid,
        title: title ?? this.title,
        description: description ?? this.description,
        type: type ?? this.type,
        genres: genres ?? this.genres,
        age: age ?? this.age,
        coverPhoto: coverPhoto ?? this.coverPhoto,
        basePhoto: basePhoto ?? this.basePhoto,
        bannerPhoto: bannerPhoto ?? this.bannerPhoto,
        duration: duration ?? this.duration,
        quality: quality ?? this.quality,
        status: status ?? this.status,
        views: views ?? this.views,
        rating: rating ?? this.rating,
        comments: comments ?? this.comments,
        releasedYear: releasedYear ?? this.releasedYear,
        dateAdded: dateAdded ?? this.dateAdded,
        link: link ?? this.link,
        trailer: trailer ?? this.trailer,
        offlineStatus: offlineStatus ?? this.offlineStatus,
        offlinePath: offlinePath ?? this.offlinePath,
      );


  factory SavedItemModel.fromJson(Map<String, dynamic> json) => SavedItemModel(
    id: json["id"] as int?,
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
    link: json["link"] as String,
    trailer: json["trailer"],
    offlineStatus: json["offline_status"],
    offlinePath: json["offline_path"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
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
    "link": link.toString(),
    "trailer": trailer,
    "offline_status": offlineStatus,
    "offline_path": offlinePath
  };
}
