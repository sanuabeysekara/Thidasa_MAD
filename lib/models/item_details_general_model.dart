// To parse this JSON data, do
//
//     final itemDetailsGeneral = itemDetailsGeneralFromJson(jsonString);

import 'dart:convert';

import 'package:news/models/review_model.dart';

import 'item_model.dart';

ItemDetailsGeneral? itemDetailsGeneralFromJson(String str) => ItemDetailsGeneral.fromJson(json.decode(str));

String itemDetailsGeneralToJson(ItemDetailsGeneral? data) => json.encode(data!.toJson());

class ItemDetailsGeneral {
  ItemDetailsGeneral({
    this.cid,
    this.is_already_reviewed,
    this.is_already_wishlisted,
    this.itemData,
    this.reviews,
  });

  String? cid;
  bool? is_already_reviewed;
  bool? is_already_wishlisted;
  ItemModel? itemData;
  List<Review?>? reviews;

  factory ItemDetailsGeneral.fromJson(Map<String, dynamic> json) => ItemDetailsGeneral(
    cid: json["cid"],
    is_already_reviewed: json["is_already_reviewed"],
    is_already_wishlisted: json["is_already_wishlisted"],
    itemData: json["item_data"] == null ? ItemModel() : ItemModel.fromJson(json["item_data"]),
    reviews: json["reviews"] == null ? [] : List<Review?>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cid": cid,
    "is_already_reviewed": is_already_reviewed,
    "is_already_wishlisted": is_already_wishlisted,
    "item_data": itemData == null ? [] : itemData!.toJson(),
    "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x!.toJson())),
  };
}
