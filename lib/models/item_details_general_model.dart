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
    this.isAlreadyReviewed,
    this.isAlreadyWishlisted,
    this.itemData,
    this.reviews,
  });

  String? cid;
  bool? isAlreadyReviewed;
  bool? isAlreadyWishlisted;
  ItemModel? itemData;
  List<Review?>? reviews;

  factory ItemDetailsGeneral.fromJson(Map<String, dynamic> json) => ItemDetailsGeneral(
    cid: json["cid"],
    isAlreadyReviewed: json["is_already_reviewed"],
    isAlreadyWishlisted: json["is_already_wishlisted"],
    itemData: json["item_data"] == null ? ItemModel() : ItemModel.fromJson(json["item_data"]),
    reviews: json["reviews"] == null ? [] : List<Review?>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cid": cid,
    "is_already_reviewed": isAlreadyReviewed,
    "is_already_wishlisted": isAlreadyWishlisted,
    "item_data": itemData == null ? [] : itemData!.toJson(),
    "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x!.toJson())),
  };
}
