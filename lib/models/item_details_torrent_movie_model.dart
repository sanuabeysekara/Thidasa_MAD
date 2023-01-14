// To parse this JSON data, do
//
//     final itemDetailsTorrentMovie = itemDetailsTorrentMovieFromJson(jsonString);

import 'dart:convert';

import 'package:news/models/genres_model.dart';
import 'package:news/models/review_model.dart';
import 'package:news/models/torent_movie_model.dart';

import 'item_model.dart';

ItemDetailsTorrentMovie? itemDetailsTorrentMovieFromJson(String str) => ItemDetailsTorrentMovie.fromJson(json.decode(str));

String itemDetailsTorrentMovieToJson(ItemDetailsTorrentMovie? data) => json.encode(data!.toJson());

class ItemDetailsTorrentMovie {
  ItemDetailsTorrentMovie({
    this.cid,
    this.is_already_reviewed,
    this.is_already_wishlisted,
    this.itemData,
    this.reviews,
    this.itemDataTorrentmovies,
  });

  String? cid;
  bool? is_already_reviewed;
  bool? is_already_wishlisted;
  ItemModel? itemData;
  List<Review?>? reviews;
  List<TorrentMovie?>? itemDataTorrentmovies;

  factory ItemDetailsTorrentMovie.fromJson(Map<String, dynamic> json) => ItemDetailsTorrentMovie(
    cid: json["cid"],
    is_already_reviewed: json["is_already_reviewed"],
    is_already_wishlisted: json["is_already_wishlisted"],
    itemData: json["item_data"] == null ? ItemModel() : ItemModel.fromJson(json["item_data"]),
    reviews: json["reviews"] == null ? [] : List<Review?>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
    itemDataTorrentmovies: json["item_data_torrentmovies"] == null ? [] : List<TorrentMovie?>.from(json["item_data_torrentmovies"]!.map((x) => TorrentMovie.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cid": cid,
    "is_already_reviewed": is_already_reviewed,
    "is_already_wishlisted": is_already_wishlisted,
    "item_data": itemData == null ? [] : itemData!.toJson(),
    "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x!.toJson())),
    "item_data_torrentmovies": itemDataTorrentmovies == null ? [] : List<dynamic>.from(itemDataTorrentmovies!.map((x) => x!.toJson())),
  };
}