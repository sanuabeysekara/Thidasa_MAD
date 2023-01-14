import 'dart:convert';

class ItemDataTvSeries{
  ItemDataTvSeries({
    this.tscid,
    this.cid,
    this.season,
    this.episode,
    this.episodeName,
    this.episodeLink,
  });

  String? tscid;
  String? cid;
  String? season;
  String? episode;
  String? episodeName;
  String? episodeLink;

  factory ItemDataTvSeries.fromJson(Map<String, dynamic> json) => ItemDataTvSeries(
    tscid: json["tscid"],
    cid: json["cid"],
    season: json["season"],
    episode: json["episode"],
    episodeName: json["episode_name"],
    episodeLink: json["episode_link"],
  );

  Map<String, dynamic> toJson() => {
    "tscid": tscid,
    "cid": cid,
    "season": season,
    "episode": episode,
    "episode_name": episodeName,
    "episode_link": episodeLink,
  };
}
