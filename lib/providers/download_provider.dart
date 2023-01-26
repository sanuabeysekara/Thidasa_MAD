import 'dart:convert';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:news/models/item_model.dart';
import 'package:news/models/token_model.dart';
import 'package:news/utils/shared_preferences.dart';

import '../constants/newsApi_constants.dart';
import '../db/saved_items_database.dart';
import '../models/articles_model.dart';
import '../models/news_model.dart';
import '../models/save_item_model.dart';
import '../models/server_response_model.dart';


class DownloadNotifier extends ChangeNotifier {


  bool isDownloading = false;
  int downloadProgress = 1;
  int downloadStatus = 0;
  String downloadFileName = "Initializing";
  String downloadID = "";
  int savedItemsDbID = 100000;


  DownloadNotifier() {

  }

  updateData() async {
    final tasks = await FlutterDownloader.loadTasksWithRawQuery(query: "SELECT * FROM task WHERE task_id='${downloadID}'");
    downloadFileName = tasks![0].filename!;
    notifyListeners();
  }



  reset(){
   isDownloading = false;
   downloadProgress = 0;
   downloadStatus = 0;
   downloadFileName = "Initializing";
   downloadID = "";
   savedItemsDbID = 100000;
   notifyListeners();

  }
  resetIfNotDownloading() async {
    final tasks = await FlutterDownloader.loadTasksWithRawQuery(query: "SELECT * FROM task WHERE task_id='${downloadID}'");
    if(tasks![0].status!.value==3 ||tasks![0].status!.value==4 ||tasks![0].status!.value==5){
      isDownloading = false;
      downloadProgress = 0;
      downloadStatus = 0;
      downloadFileName = "Initializing";
      downloadID = "";
      savedItemsDbID = 100000;
      notifyListeners();
    }

  }

  redirectIfDownloading() async {

      isDownloading = isDownloading;
      print("Download Is loading Provider " + isDownloading.toString());
      notifyListeners();


  }

  Future<bool>cancel() async {
    FlutterDownloader.cancel(taskId: downloadID);
    await SavedItemsDatabase.instance.delete(savedItemsDbID);
    return true;
  }


}


// Finally, we are using StateNotifierProvider to allow the UI to interact with
// our TodosNotifier class.
final downloadProvider = ChangeNotifierProvider<DownloadNotifier>((ref) {
  return DownloadNotifier();
});


