import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../constants/newsApi_constants.dart';
import '../models/articles_model.dart';
import '../models/news_model.dart';


class NewsNotifier extends ChangeNotifier {
  List<ArticleModel> allNews = <ArticleModel>[];
// for carousel
  List<ArticleModel> breakingNews = <ArticleModel>[];
  ScrollController scrollController = ScrollController();
  bool articleNotFound = false;
  bool isLoading = false;
  bool hasMore = true;
  String cName = '';
  String country = '';
  String category = '';
  String channel = '';
  String searchNews = '';
  int pageNum = 1;
  int pageSize = 10;
  String baseUrl = "https://newsapi.org/v2/top-headlines?";

  NewsNotifier(){
    scrollController = ScrollController()..addListener(_scrollListener);
    getAllNews();
    getBreakingNews();
  }





  _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      isLoading = true;
      if(hasMore){
      getAllNews();}
      else{
        print('Has More is false therefore get all news didnt implemented');
      }
      print("Scroll Activated");

    }
  }

  reset(){
    country = '';
    category = '';
    searchNews = '';
    channel = '';
    cName = '';
    hasMore = true;
    getAllNews(reload: true);
    getBreakingNews(reload: true);
    notifyListeners();

  }

  getBreakingNews({reload = false}) async {
    articleNotFound = false;

    if (!reload && isLoading == false) {
    } else {
      country = '';
    }
    if (isLoading == true) {
      pageNum++;
    } else {
      breakingNews = [];

      pageNum = 1;
    }
    // default language is set to English
    /// ENDPOINT
    baseUrl =
    "https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&languages=en&";
    // default country is set to US
    baseUrl += country.isEmpty ? 'country=us&' : 'country=$country&';
    //baseApi += category.isEmpty ? '' : 'category=$category&';
    baseUrl += 'apiKey=${NewsApiConstants.newsApiKey}';
    print([baseUrl]);
    // calling the API function and passing the URL here
    getBreakingNewsFromApi(baseUrl);
  }

  // function to load and display all news and searched news on to UI
  getAllNews({channel = '', searchKey = '', reload = false}) async {
    articleNotFound = false;

    if (!reload && isLoading == false) {
    } else {
      country = '';
      category = '';
    }
    if (isLoading == true) {
      pageNum++;
    } else {
      allNews = [];

      pageNum = 1;
    }
    // ENDPOINT
    baseUrl = "https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&";
    // default country is set to India
    baseUrl += country.isEmpty ? 'country=in&' : 'country=$country&';
    // default category is set to Business
    baseUrl += category.isEmpty ? 'category=business&' : 'category=$category&';
    baseUrl += 'apiKey=${NewsApiConstants.newsApiKey}';
    if (channel != '') {
      country = '';
      category = '';
      baseUrl =
      "https://newsapi.org/v2/top-headlines?sources=$channel&apiKey=${NewsApiConstants.newsApiKey}";
    }
    if (searchKey != '') {
      country = '';
      category = '';
      baseUrl =
      "https://newsapi.org/v2/everything?q=$searchKey&sortBy=popularity&pageSize=10&apiKey=${NewsApiConstants.newsApiKey}";
    }
    print(baseUrl);
    // calling the API function and passing the URL here
    getAllNewsFromApi(baseUrl);
  }
  getBreakingNewsFromApi(url) async {
    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      NewsModel newsData = NewsModel.fromJson(jsonDecode(res.body));


      if (newsData.articles.isEmpty && newsData.totalResults == 0) {
        articleNotFound = isLoading == true ? false : true;
        isLoading = false;
        notifyListeners();
      } else {
        if (isLoading == true) {
          // combining two list instances with spread operator
          breakingNews = [...breakingNews, ...newsData.articles];
          notifyListeners();
        } else {
          if (newsData.articles.isNotEmpty) {
            breakingNews = newsData.articles;
            if (scrollController.hasClients) scrollController.jumpTo(0.0);
            notifyListeners();
          }
        }
        articleNotFound = false;
        isLoading = false;
        notifyListeners();
      }
    } else {
      articleNotFound = true;
      notifyListeners();
    }
  }

  getAllNewsFromApi(url) async {
    //Creates a new Uri object by parsing a URI string.
    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      //Parses the string and returns the resulting Json object.
      NewsModel newsData = NewsModel.fromJson(jsonDecode(res.body));
      if(newsData.articles.length<10){
        hasMore = false;
      }
      if (newsData.articles.isEmpty && newsData.totalResults == 0) {
        articleNotFound = isLoading == true ? false : true;
        isLoading = false;
        notifyListeners();
      } else {
        if (isLoading == true) {
          // combining two list instances with spread operator
          allNews = [...allNews, ...newsData.articles];
          notifyListeners();
        } else {
          if (newsData.articles.isNotEmpty) {
            allNews = newsData.articles;
            // list scrolls back to the start of the screen
            if (scrollController.hasClients) scrollController.jumpTo(0.0);
            notifyListeners();
          }
        }
        articleNotFound = false;
        isLoading = false;
        notifyListeners();
      }
    } else {
      articleNotFound = true;
      notifyListeners();
    }
  }
}

// Finally, we are using StateNotifierProvider to allow the UI to interact with
// our TodosNotifier class.
final newsProvider = ChangeNotifierProvider<NewsNotifier>((ref) {
  return NewsNotifier();
});