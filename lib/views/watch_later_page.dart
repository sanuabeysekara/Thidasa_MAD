import 'dart:isolate';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:news/constants/color_constants.dart';
import 'package:news/constants/size_constants.dart';
import 'package:news/constants/ui_constants.dart';
import 'package:news/controllers/news_controller.dart';
import 'package:news/db/saved_items_database.dart';
import 'package:news/models/genres_model.dart';
import 'package:news/models/save_item_model.dart';
import 'package:news/models/saved_item_model.dart';
import 'package:news/providers/genres_provider.dart';
import 'package:news/providers/http_provider.dart';
import 'package:news/providers/news_provider.dart';
import 'package:news/views/filter_page.dart';
import 'package:news/views/home_page.dart';
import 'package:news/views/offline_player_page.dart';
import 'package:news/views/settings_page.dart';
import 'package:news/views/view_page.dart';
import 'package:news/views/web_view_news.dart';
import 'package:news/views/your_page.dart';
import 'package:news/widgets/custom_appBar.dart';
import 'package:news/widgets/news_card.dart';
//import 'package:news/widgets/side_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:news/widgets/saved_item_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/articles_model.dart';
import '../models/item_model.dart';
import '../providers/navigation_provider.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/genre_card.dart';
import '../widgets/item_card.dart';
import '../widgets/shimmer_widget.dart';

class WatchLaterPage extends ConsumerStatefulWidget {
  WatchLaterPage({Key? key}) : super(key: key);

  @override
  _WatchLaterPagePageState createState() => _WatchLaterPagePageState();
}

class _WatchLaterPagePageState extends ConsumerState<WatchLaterPage> {
  TextEditingController searchController = TextEditingController();
  late List<ItemModel> favoriteItems;
  bool isCustomLoading = false;
  bool downloading = false;
  var progressString = "";
  bool hasInternet = false;
  bool isDownloadOnProgress = false;
  Future<List<SavedItemModel>> savedItemsList =
      SavedItemsDatabase.instance.readAllItems();

  int progress = 0;
  int downloadStatus = 0;
  String downloadItemName = "Initializing";
  String downloadTaskId = "Initializing";
  late final tasks;

  late ReceivePort _receivePort;

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");
    print("hey kollo");

    ///ssending the data
    sendPort?.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();
    //ref.read(httpProvider).getWishList();
  }

  @override
  void dispose() {
    //DBHelper.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //List<ItemModel> searchedItems = ref.read(httpProvider).wishListItems;

    //print(searchedItems);
    return FutureBuilder(
        future: ref.read(httpProvider).getWishListItemsFromApi(),
        builder: (context, snapshot) {
          snapshot.data.toString();

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  //SizedBox(height: 15),
                  //Text(progressString),
                  //SizedBox(height: 10),
                  //Text("Loading..."),
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                List<ItemModel> searchedItems = snapshot.data!;
                print(searchedItems);
                return Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: ScrollBehavior(),
                        child: GlowingOverscrollIndicator(
                          axisDirection: AxisDirection.down,
                          color: AppColors.thidasaBlue,
                          child: ListView(
                            children: [
                              Visibility(
                                child: StaggeredGridView.countBuilder(
                                  padding: EdgeInsets.all(8),
                                  itemCount: searchedItems.length,
                                  shrinkWrap: true,
                                  //controller: ref.watch(newsProvider).scrollController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  staggeredTileBuilder: (index) =>
                                      StaggeredTile.fit(2),
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 20,
                                  itemBuilder: (context, index) {
                                    if (searchedItems.isNotEmpty) {
                                      return InkWell(
                                        // onTap: () => Get.to(() => WebViewNews(
                                        //     newsUrl: allNews[index].url)),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewPage(
                                                        cid:
                                                            searchedItems[index]
                                                                .cid,
                                                        type:
                                                            searchedItems[index]
                                                                .type,
                                                      )));
                                        },
                                        child: ItemCard(
                                            searchedItems[index].cid!,
                                            searchedItems[index].coverPhoto!,
                                            searchedItems[index].title!,
                                            searchedItems[index].type!,
                                            searchedItems[index].rating!,
                                            searchedItems[index].genres!),
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  },
                                ),
                                maintainAnimation: true,
                                maintainState: true,
                                visible: true,
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              else {
                return Column(
                  children: [
                    Image.asset('assets/images/no_results_found.png'),
                    Padding(padding:EdgeInsets.all(10),
                      child:Text("Oops! No Results Found", style: TextStyle(
                          fontSize: Sizes.dimen_26,
                          color: AppColors.white,
                          fontWeight: FontWeight.w300
                      ),)
                      ,
                    )
                  ],
                );
              }
            } else {
              return const Text('Empty data');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        });

    Scaffold(
      backgroundColor: AppColors.thidasaDarkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.thidasaBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: Text("Favourite Shows"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: AppColors.thidasaBlue,
                child: ListView(
                  children: [
                    isCustomLoading == true
                        ? Visibility(
                            child: StaggeredGridView.countBuilder(
                              padding: EdgeInsets.all(8),
                              itemCount: 18,
                              shrinkWrap: true,
                              //controller: ref.watch(newsProvider).scrollController,
                              physics: const NeverScrollableScrollPhysics(),
                              staggeredTileBuilder: (index) =>
                                  StaggeredTile.fit(2),
                              crossAxisCount: 4,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              itemBuilder: (context, index) {
                                if (true) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.thidasaBlue,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    height: 300,
                                    child: ShimmerWidget.rectangular(
                                      height: 300,
                                      shapeBorder: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            ),
                            maintainAnimation: true,
                            maintainState: true,
                          )
                        : favoriteItems.isNotEmpty
                            ? Visibility(
                                child: StaggeredGridView.countBuilder(
                                  padding: EdgeInsets.all(8),
                                  itemCount: favoriteItems.length,
                                  shrinkWrap: true,
                                  //controller: ref.watch(newsProvider).scrollController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  staggeredTileBuilder: (index) =>
                                      StaggeredTile.fit(2),
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 20,
                                  itemBuilder: (context, index) {
                                    if (favoriteItems.isNotEmpty) {
                                      return InkWell(
                                        // onTap: () => Get.to(() => WebViewNews(
                                        //     newsUrl: allNews[index].url)),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewPage(
                                                        cid:
                                                            favoriteItems[index]
                                                                .cid,
                                                        type:
                                                            favoriteItems[index]
                                                                .type,
                                                      )));
                                        },
                                        child: ItemCard(
                                            favoriteItems[index].cid!,
                                            favoriteItems[index].coverPhoto!,
                                            favoriteItems[index].title!,
                                            favoriteItems[index].type!,
                                            favoriteItems[index].rating!,
                                            favoriteItems[index].genres!),
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  },
                                ),
                                maintainAnimation: true,
                                maintainState: true,
                              )
                            : Visibility(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/no_results_found.png'),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Oops! No Results Found",
                                          style: TextStyle(
                                              fontSize: Sizes.dimen_26,
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                maintainAnimation: true,
                                maintainState: true,
                                visible: favoriteItems.isEmpty,
                              ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
