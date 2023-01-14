import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:news/models/item_model.dart';
import 'package:news/models/token_model.dart';
import 'package:news/utils/shared_preferences.dart';

import '../constants/newsApi_constants.dart';
import '../models/articles_model.dart';
import '../models/news_model.dart';
import '../models/server_response_model.dart';


class HttpNotifier extends ChangeNotifier {
  List<ItemModel> allItems = <ItemModel>[];

// for carousel
  List<ItemModel> searchedItems = <ItemModel>[];
  List<ItemModel> latestItems = <ItemModel>[];
  ScrollController scrollController = ScrollController();
  String token = UserSharedPreferences.getToken()??"";
  String name = UserSharedPreferences.getName()??"";
  bool isSearchedItemsLoading = true;
  bool itemNotFound = false;
  String baseURL="";

  ItemsNotifier() {

  }


  Future<bool> signIn(map) async {
    http.Response res = await http.post(
      Uri.parse(ThidasaApiConstants.appURL+"login"),
      body: map,
    );
    if (res.statusCode == 200) {
      final jsonArray = jsonDecode(res.body);
      final Token token = Token.fromJson(jsonArray);
      if(token.token!.isNotEmpty){
        UserSharedPreferences.setToken(token.token!);
        UserSharedPreferences.setName(token.user!.name!);
        UserSharedPreferences.setID(token.user!.uid!);
        UserSharedPreferences.setEmail(token.user!.email!);
        print(UserSharedPreferences.getToken());
        return true;
      }
      else{
        return false;
      }

      notifyListeners();

    } else {
      notifyListeners();
      return false;

    }
  }
  Future<ServerResponse> signUp(map) async {
    http.Response res = await http.post(
      Uri.parse(ThidasaApiConstants.appURL+"register"),
      body: map,
    );
    if (res.statusCode == 200) {
      final jsonArray = jsonDecode(res.body);
      final ServerResponse serverResponse = ServerResponse.fromJson(jsonArray);
      return serverResponse;

    } else {
      notifyListeners();
      return ServerResponse();

    }
  }
  Future<ServerResponse> editProfile(map) async {
    http.Response res = await http.post(
      Uri.parse(ThidasaApiConstants.appURL+"edit_profile"),
      body: map,
    );
    if (res.statusCode == 200) {
      final jsonArray = jsonDecode(res.body);
      final ServerResponse serverResponse = ServerResponse.fromJson(jsonArray);
      return serverResponse;

    } else {
      notifyListeners();
      return ServerResponse();

    }
  }


  Future<ServerResponse> addToWishList(map) async {
    http.Response res = await http.post(
      Uri.parse(ThidasaApiConstants.appURL+"add_wishlist"),
      body: map,
    );
    if (res.statusCode == 200) {
      final jsonArray = jsonDecode(res.body);
      final ServerResponse serverResponse = ServerResponse.fromJson(jsonArray);
      return serverResponse;

    } else {
      notifyListeners();
      return ServerResponse();

    }
  }


  Future<ServerResponse> removeFromWishList(map) async {
    print(map);
    print(ThidasaApiConstants.appURL+"remove_wishlist");
    http.Response res = await http.post(
      Uri.parse(ThidasaApiConstants.appURL+"remove_wishlist"),
      body: map,
    );
    if (res.statusCode == 200) {
      final jsonArray = jsonDecode(res.body);
      final ServerResponse serverResponse = ServerResponse.fromJson(jsonArray);
      return serverResponse;

    } else {
      notifyListeners();
      return ServerResponse();

    }
  }

  Future<ServerResponse> addReview(map) async {
    http.Response res = await http.post(
      Uri.parse(ThidasaApiConstants.appURL+"add_review"),
      body: map,
    );
    if (res.statusCode == 200) {
      final jsonArray = jsonDecode(res.body);
      final ServerResponse serverResponse = ServerResponse.fromJson(jsonArray);
      return serverResponse;

    } else {
      notifyListeners();
      return ServerResponse();

    }
  }

  getSearchedItems(String key) async {
    isSearchedItemsLoading = true;
    itemNotFound = false;


    baseURL = ThidasaApiConstants.appURL+"search/"+key;

    print([baseURL]);
    // calling the API function and passing the URL here
    getSearchedItemsFromApi(baseURL);
  }


  getSortedItems(String key) async {
    isSearchedItemsLoading = true;
    itemNotFound = false;


    baseURL = ThidasaApiConstants.appURL+"sort/"+key;

    print([baseURL]);
    // calling the API function and passing the URL here
    getSortedItemsFromApi(baseURL);
  }
  getSortedItemsFromApi(url) async {
    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      List<ItemModel> items = (jsonDecode(res.body) as List<dynamic>).map((e) =>
          ItemModel.fromJson(e as Map<String, dynamic>)).toList();

      if (items.isEmpty && items.length == 0) {
        itemNotFound = true;
        isSearchedItemsLoading = false;
        searchedItems = [];
        notifyListeners();
      } else {
        if (isSearchedItemsLoading == true) {
          // combining two list instances with spread operator
          searchedItems = items;
          if (scrollController.hasClients) scrollController.jumpTo(0.0);
          notifyListeners();
        } else {
          if (items.isNotEmpty) {
            searchedItems = items;
            if (scrollController.hasClients) scrollController.jumpTo(0.0);
            notifyListeners();
          }
        }
        itemNotFound = false;
        Future.delayed(const Duration(seconds: 4),(){
          isSearchedItemsLoading = false;
          notifyListeners();

        });        notifyListeners();
      }
    } else {
      searchedItems = [];
      itemNotFound = true;
      notifyListeners();
    }
  }


  getSearchedItemsFromApi(url) async {
    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      List<ItemModel> items = (jsonDecode(res.body) as List<dynamic>).map((e) =>
          ItemModel.fromJson(e as Map<String, dynamic>)).toList();

      if (items.isEmpty && items.length == 0) {
        itemNotFound = true;
        isSearchedItemsLoading = false;
        searchedItems = [];
        notifyListeners();
      } else {
        if (isSearchedItemsLoading == true) {
          // combining two list instances with spread operator
          searchedItems = items;
          if (scrollController.hasClients) scrollController.jumpTo(0.0);
          notifyListeners();
        } else {
          if (items.isNotEmpty) {
            searchedItems = items;
            if (scrollController.hasClients) scrollController.jumpTo(0.0);
            notifyListeners();
          }
        }
        itemNotFound = false;
        Future.delayed(const Duration(seconds: 4),(){
          isSearchedItemsLoading = false;
          notifyListeners();

        });        notifyListeners();
      }
    } else {
      searchedItems = [];
      itemNotFound = true;
      notifyListeners();
    }
  }


  updateSharedPreferenses(){
    this.token = UserSharedPreferences.getToken()??"";
    this.name = UserSharedPreferences.getName()??"";
    notifyListeners();

  }

}


// Finally, we are using StateNotifierProvider to allow the UI to interact with
// our TodosNotifier class.
final httpProvider = ChangeNotifierProvider<HttpNotifier>((ref) {
  return HttpNotifier();
});


