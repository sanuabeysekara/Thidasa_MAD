// To parse this JSON data, do
//
//     final watchLater = watchLaterFromJson(jsonString);

import 'dart:convert';

final String tableWatchLater = 'watch_later';

class WatchLaterFields{

  static final List<String> values = [
    /// Add all fields
    id, cid, uid,timeAdded
  ];

  static final String id= '_id';
  static final String cid= 'cid';
  static final String uid= 'uid';
  static final String timeAdded= 'timeAdded';


}

class WatchLater {
  WatchLater({
    this.id,
    this.cid,
    this.uid,
    this.timeAdded,
  });

  int? id;
  String? cid;
  String? uid;
  DateTime? timeAdded;

  WatchLater copyWith({
    int? id,
    String? cid,
    String? uid,
    DateTime? timeAdded,
  }) =>
      WatchLater(
        id: id ?? this.id,
        cid: cid ?? this.cid,
        uid: uid ?? this.uid,
        timeAdded: timeAdded ?? this.timeAdded,
      );

  factory WatchLater.fromJson(Map<String, dynamic> json) => WatchLater(
    id: json["id"],
    cid: json["cid"],
    uid: json["uid"],
    timeAdded: DateTime.parse(json["time_added"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cid": cid,
    "uid": uid,
    "time_added": "${timeAdded!.year.toString().padLeft(4, '0')}-${timeAdded!.month.toString().padLeft(2, '0')}-${timeAdded!.day.toString().padLeft(2, '0')}",
  };
}
