import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:news/models/genres_model.dart';
import 'package:news/models/item_model.dart';
import 'package:news/utils/shared_preferences.dart';

import '../constants/newsApi_constants.dart';
import '../models/articles_model.dart';
import '../models/news_model.dart';


class GenresNotifier extends ChangeNotifier {
  List<GenreModel> allGenres = <GenreModel>[];
  bool itemNotFound = false;
  bool isGenreLoading = true;

// for carousel



  GenresNotifier() {

    getGenreItems();  }


  getGenreItemsInit() async {
    String url = ThidasaApiConstants.appURL+"catalogue_genres";
    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      List<GenreModel> items = (jsonDecode(res.body) as List<dynamic>).map((e) =>
          GenreModel.fromJson(e as Map<String, dynamic>)).toList();

      if (items.isEmpty && items.length == 0) {
        itemNotFound = true;
        notifyListeners();


      } else {
        itemNotFound = false;
        allGenres = items;

        notifyListeners();

      }
    } else {
      itemNotFound = true;
      notifyListeners();
    }
  }

  getGenreItems() async {
    String url = ThidasaApiConstants.appURL+"catalogue_genres";
    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      List<GenreModel> items = (jsonDecode(res.body) as List<dynamic>).map((e) =>
          GenreModel.fromJson(e as Map<String, dynamic>)).toList();

      if (items.isEmpty && items.length == 0) {
        itemNotFound = true;
        notifyListeners();
        isGenreLoading = true;


      } else {
        itemNotFound = false;
        allGenres = items;
        Future.delayed(const Duration(seconds: 2),(){
          isGenreLoading = false;
          notifyListeners();
          print("Hi kollo");

        });
        notifyListeners();

      }
    } else {
      isGenreLoading = true;
      itemNotFound = true;
      notifyListeners();
    }
  }


}
// Finally, we are using StateNotifierProvider to allow the UI to interact with
// our TodosNotifier class.
  final genresProvider = ChangeNotifierProvider<GenresNotifier>((ref) {
    return GenresNotifier();
  });

final genresPageProvider = ChangeNotifierProvider<GenresNotifier>((ref) {
  return GenresNotifier();
});


