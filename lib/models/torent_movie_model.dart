// To parse this JSON data, do
//
//     final torrentMovie = torrentMovieFromJson(jsonString);

import 'dart:convert';

TorrentMovie? torrentMovieFromJson(String str) => TorrentMovie.fromJson(json.decode(str));

String torrentMovieToJson(TorrentMovie? data) => json.encode(data!.toJson());

class TorrentMovie {
  TorrentMovie({
    this.torrentMovieId,
    this.cid,
    this.hd,
    this.fullhd,
    this.uhd,
  });

  String? torrentMovieId;
  String? cid;
  String? hd;
  String? fullhd;
  String? uhd;

  factory TorrentMovie.fromJson(Map<String, dynamic> json) => TorrentMovie(
    torrentMovieId: json["torrent_movie_id"],
    cid: json["cid"],
    hd: json["hd"],
    fullhd: json["fullhd"],
    uhd: json["uhd"],
  );

  Map<String, dynamic> toJson() => {
    "torrent_movie_id": torrentMovieId,
    "cid": cid,
    "hd": hd,
    "fullhd": fullhd,
    "uhd": uhd,
  };
}
