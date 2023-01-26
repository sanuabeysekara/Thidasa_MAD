import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:news/models/item_details_torrent_movie_model.dart';
import 'package:news/models/item_model.dart';
import 'package:news/models/token_model.dart';
import 'package:news/models/tv_series_model.dart';
import 'package:news/utils/shared_preferences.dart';

import '../constants/newsApi_constants.dart';
import '../models/articles_model.dart';
import '../models/item_details_general_model.dart';
import '../models/item_details_tv_series_model.dart';
import '../models/news_model.dart';
import '../models/server_response_model.dart';


class ItemDetailsNotifier extends ChangeNotifier {
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

  Future<String?> getItemType(String cid) async {
    http.Response res = await http.post(
      Uri.parse(ThidasaApiConstants.appURL+"item_type/"+cid),
    );
    if (res.statusCode == 200) {
      final jsonArray = jsonDecode(res.body);
      final ServerResponse serverResponse = ServerResponse.fromJson(jsonArray);
      return serverResponse.message;

    } else {
      notifyListeners();
      return "";

    }
  }

  Future<ItemDetailsTvSeries> getTVSeriesDetails(String cid) async {
    String uid;
    if(UserSharedPreferences.getToken()!=null){
      uid = UserSharedPreferences.getID()!;
    }
    else{
      uid = "";
    }

    http.Response res = await http.get(
      Uri.parse(ThidasaApiConstants.appURL+"view/"+cid+"/"+uid),
    );
    if (res.statusCode == 200) {
      print("Successfully Retrived TV Series Data");
      final jsonArray = jsonDecode(res.body);
      print(jsonArray);
      final ItemDetailsTvSeries itemDetails = ItemDetailsTvSeries.fromJson(jsonArray);
      //print("Successfully Retrived TV Series Data");

      print(itemDetails.itemData?.coverPhoto);
      return itemDetails;

    } else {
      print("Unsuccessfully Retrived TV Series Data");

      notifyListeners();
      return ItemDetailsTvSeries();

    }
  }

  Future<ItemDetailsTorrentMovie> getTorrentMovieDetails(String cid) async {
    String uid="";
    if(UserSharedPreferences.getToken()!=null){
      uid = UserSharedPreferences.getID()!;
    }

    http.Response res = await http.get(
      Uri.parse(ThidasaApiConstants.appURL+"view/"+cid+"/"+uid),
    );
    if (res.statusCode == 200) {
      print("Successfully Retrived Torrent Movie Data");
      final jsonArray = jsonDecode(res.body);
      print(jsonArray);
      final ItemDetailsTorrentMovie itemDetails = ItemDetailsTorrentMovie.fromJson(jsonArray);
      //print("Successfully Retrived TV Series Data");

      print(itemDetails.itemData?.coverPhoto);
      return itemDetails;

    } else {
      print("Unsuccessfully Retrived Torrent Movie Data");

      notifyListeners();
      return ItemDetailsTorrentMovie();

    }
  }

  Future<ItemDetailsGeneral> getGeneralDetails(String cid) async {
    String uid="";
    if(UserSharedPreferences.getToken()!=null){
      uid = UserSharedPreferences.getID()!;
    }


    http.Response res = await http.get(
      Uri.parse(ThidasaApiConstants.appURL+"view/"+cid+"/"+uid),
    );
    if (res.statusCode == 200) {
      print("Successfully Retrived General Show Data");
      final jsonArray = jsonDecode(res.body);
      print(jsonArray);
      final ItemDetailsGeneral itemDetails = ItemDetailsGeneral.fromJson(jsonArray);

      print(itemDetails.itemData?.coverPhoto);
      return itemDetails;

    } else {
      notifyListeners();
      return ItemDetailsGeneral();

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



}


// Finally, we are using StateNotifierProvider to allow the UI to interact with
// our TodosNotifier class.
final itemDetailsProvider = ChangeNotifierProvider<ItemDetailsNotifier>((ref) {
  return ItemDetailsNotifier();
});


