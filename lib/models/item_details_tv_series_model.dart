// To parse this JSON data, do
//
//     final itemDetails = itemDetailsFromJson(jsonString);

import 'dart:convert';

import 'package:news/models/review_model.dart';
import 'package:news/models/tv_series_model.dart';

import 'genres_model.dart';
import 'item_model.dart';

ItemDetailsTvSeries? ItemDetailsTvSeriesFromJson(String str) => ItemDetailsTvSeries.fromJson(json.decode(str));

String ItemDetailsTvSeriesToJson(ItemDetailsTvSeries? data) => json.encode(data!.toJson());

class ItemDetailsTvSeries {
  ItemDetailsTvSeries({
    this.cid,
    this.is_already_reviewed,
    this.is_already_wishlisted,
    this.itemData,
    this.reviews,
    this.itemDataTvseries,
  });

  String? cid;
  bool? is_already_reviewed;
  bool? is_already_wishlisted;
  ItemModel? itemData;
  List<Review?>? reviews;
  List<List<ItemDataTvSeries?>?>? itemDataTvseries;

  factory ItemDetailsTvSeries.fromJson(Map<String, dynamic> json){
    return ItemDetailsTvSeries(
      cid: json["cid"],
      is_already_reviewed: json["is_already_reviewed"],
      is_already_wishlisted: json["is_already_wishlisted"],
      itemData: json["item_data"] == null ? ItemModel() : ItemModel.fromJson(json["item_data"]),
      reviews: json["reviews"] == null ? [] : List<Review?>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
      itemDataTvseries: json["item_data_tvseries"] == null ? [] : List<List<ItemDataTvSeries?>?>.from(json["item_data_tvseries"]!.map((x) => x == null ? [] : List<ItemDataTvSeries?>.from(x!.map((x) => ItemDataTvSeries.fromJson(x))))),
    );
  }

  Map<String, dynamic> toJson() => {
    "cid": cid,
    "is_already_reviewed": is_already_reviewed,
    "is_already_wishlisted": is_already_wishlisted,
    "item_data": itemData == null ? [] : itemData!.toJson(),
    "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x!.toJson())),
    "item_data_tvseries": itemDataTvseries == null ? [] : List<dynamic>.from(itemDataTvseries!.map((x) => x == null ? [] : List<dynamic>.from(x!.map((x) => x!.toJson())))),
  };
}



