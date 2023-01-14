// To parse this JSON data, do
//
//     final genreModel = genreModelFromJson(jsonString);

import 'dart:convert';

GenreModel? genreModelFromJson(String str) => GenreModel.fromJson(json.decode(str));

String genreModelToJson(GenreModel? data) => json.encode(data!.toJson());

class GenreModel {
  GenreModel({
    this.genreId,
    this.genreName,
    this.genreImage,
  });

  String? genreId;
  String? genreName;
  String? genreImage;

  factory GenreModel.fromJson(Map<String, dynamic> json) => GenreModel(
    genreId: json["genre_id"],
    genreName: json["genre_name"],
    genreImage: json["genre_image"],
  );

  Map<String, dynamic> toJson() => {
    "genre_id": genreId,
    "genre_name": genreName,
    "genre_image": genreImage,
  };
}
