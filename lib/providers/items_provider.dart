import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:news/models/item_model.dart';
import 'package:news/utils/shared_preferences.dart';

import '../constants/newsApi_constants.dart';
import '../models/articles_model.dart';
import '../models/news_model.dart';


class ItemsNotifier extends ChangeNotifier {
  List<ItemModel> allItems = <ItemModel>[];

// for carousel
  List<ItemModel> trendingItems = <ItemModel>[];
  List<ItemModel> latestItems = <ItemModel>[];
  ScrollController scrollController = ScrollController();
  bool itemNotFound = false;
  bool isLoading = false;
  bool isLatestItemsLoading = false;
  bool hasMore = true;
  String cName = '';
  String country = UserSharedPreferences.getDefaultCountry() == null
      ? ""
      : UserSharedPreferences.getDefaultCountry()!;
  String category = UserSharedPreferences.getDefaultCategory() == null
      ? ""
      : UserSharedPreferences.getDefaultCategory()!;
  String channel = '';
  String searchItems = '';
  int pageNum = 1;
  int pageSize = 10;
  String baseUrl = "";

  ItemsNotifier() {
    scrollController = ScrollController()
      ..addListener(_scrollListener);
    //getAllNews();
    getTrendingItems();
    getLatestItems();
    if(UserSharedPreferences.getToken()!=null){
      initializeFavourites();
    }
  }


  _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      isLoading = true;
      isLatestItemsLoading = true;
      if (hasMore) {
        //getAllNews();
      }
      else {
        print('Has More is false therefore get all news didnt implemented');
      }
      print("Scroll Activated");
    }
  }

  refresh() {
    getTrendingItems();
    getLatestItems();
    if(UserSharedPreferences.getToken()!=null){
      initializeFavourites();
    }
    notifyListeners();
    // getAllNews(reload: true);
    // getBreakingNews(reload: true);
    if (scrollController.hasClients) scrollController.jumpTo(0.0);
    notifyListeners();
  }


  getTrendingItems({reload = false}) async {
    isLoading = true;

    itemNotFound = false;


    baseUrl = ThidasaApiConstants.appURL+"trending_list/";

    print([baseUrl]);
    // calling the API function and passing the URL here
    getTrendingItemsFromApi(baseUrl);
  }

  getLatestItems({reload = false}) async {
    isLatestItemsLoading = true;
    itemNotFound = false;


    baseUrl = ThidasaApiConstants.appURL+"latest_list/";

    print([baseUrl]);
    // calling the API function and passing the URL here
    getLatestItemsFromApi(baseUrl);
  }

  getTrendingItemsFromApi(url) async {
    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      List<ItemModel> items = (jsonDecode(res.body) as List<dynamic>).map((e) =>
          ItemModel.fromJson(e as Map<String, dynamic>)).toList();

      if (items.isEmpty && items.length == 0) {
        itemNotFound = isLoading == true ? false : true;
        isLoading = false;
        notifyListeners();
      } else {
        if (isLoading == true) {
          // combining two list instances with spread operator
          trendingItems = [...trendingItems, ...items];
          notifyListeners();
        } else {
          if (items.isNotEmpty) {
            trendingItems = items;
            if (scrollController.hasClients) scrollController.jumpTo(0.0);
            notifyListeners();
          }
        }
        itemNotFound = false;
        Future.delayed(const Duration(seconds: 4),(){
          isLoading = false;
          notifyListeners();

        });
        notifyListeners();
      }
    } else {
      itemNotFound = true;
      notifyListeners();
    }
  }

  getLatestItemsFromApi(url) async {
    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      List<ItemModel> items = (jsonDecode(res.body) as List<dynamic>).map((e) =>
          ItemModel.fromJson(e as Map<String, dynamic>)).toList();

      if (items.isEmpty && items.length == 0) {
        itemNotFound = isLatestItemsLoading == true ? false : true;
        isLatestItemsLoading = false;
        notifyListeners();
      } else {
        if (isLatestItemsLoading == true) {
          // combining two list instances with spread operator
          latestItems = [...latestItems, ...items];
          notifyListeners();
        } else {
          if (items.isNotEmpty) {
            latestItems = items;
            if (scrollController.hasClients) scrollController.jumpTo(0.0);
            notifyListeners();
          }
        }
        itemNotFound = false;
        Future.delayed(const Duration(seconds: 4),(){
          isLatestItemsLoading = false;
          notifyListeners();

        });        notifyListeners();
      }
    } else {
      itemNotFound = true;
      notifyListeners();
    }
  }

  initializeFavourites({reload = false}) async {
    isLatestItemsLoading = true;
    itemNotFound = false;


    baseUrl = ThidasaApiConstants.appURL+"favourite_list/"+UserSharedPreferences.getID()!;

    print([baseUrl]);
    // calling the API function and passing the URL here
    getLatestItemsFromApi(baseUrl);
  }

  getLatestFavouritesFromApi(url) async {
    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      List<ItemModel> items = (jsonDecode(res.body) as List<dynamic>).map((e) =>
          ItemModel.fromJson(e as Map<String, dynamic>)).toList();

      if (items.isEmpty && items.length == 0) {
        itemNotFound = isLatestItemsLoading == true ? false : true;
        isLatestItemsLoading = false;
        notifyListeners();
      } else {
        if (isLatestItemsLoading == true) {
          // combining two list instances with spread operator
          latestItems = [...latestItems, ...items];
          notifyListeners();
        } else {
          if (items.isNotEmpty) {
            latestItems = items;
            if (scrollController.hasClients) scrollController.jumpTo(0.0);
            notifyListeners();
          }
        }
        itemNotFound = false;
        Future.delayed(const Duration(seconds: 4),(){
          isLatestItemsLoading = false;
          notifyListeners();

        });        notifyListeners();
      }
    } else {
      itemNotFound = true;
      notifyListeners();
    }
  }


}
// Finally, we are using StateNotifierProvider to allow the UI to interact with
// our TodosNotifier class.
  final itemsProvider = ChangeNotifierProvider<ItemsNotifier>((ref) {
    return ItemsNotifier();
  });


