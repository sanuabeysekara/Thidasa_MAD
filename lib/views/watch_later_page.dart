import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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

  @override
  void initState() {

    super.initState();
    // ref.read(genresProvider).isGenreLoading = true;
    // ref.read(genresProvider).getGenreItems();


  }

  @override
  void dispose() {
    //DBHelper.instance.close();

    super.dispose();
  }


  Future<void> downloadFile(SavedItemModel saveditem) async {
    Dio dio = Dio();
    String myURL ="";
    String OriginURL = saveditem.link??"";
    try {
      var dir = await getApplicationDocumentsDirectory();
      print("path ${dir.path}");
      myURL = "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4";
      print("My URL"+myURL);
      await dio.download(OriginURL, myURL,
          onReceiveProgress: (rec, total) {
            print("Rec: $rec , Total: $total");

            setState(() {
              downloading = true;
              progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
            });
          });
    } catch (e) {
      print(e);
    }

    SavedItemModel updatedSavedItem = saveditem.copyWith(
      offlineStatus: "downloaded",
      offlinePath: myURL,
    );

    await SavedItemsDatabase.instance.update(updatedSavedItem);
    print("Updated Saved Item "+updatedSavedItem!.id!.toString());

    SavedItemModel newSavedItem = await SavedItemsDatabase.instance.readItem(updatedSavedItem.id!);

    print("BASE64 Image");
    print(newSavedItem.coverPhoto);

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }


  @override
  Widget build(BuildContext context) {

    print("me inne issa");
    return FutureBuilder(
        future: SavedItemsDatabase.instance.readAllItems(),
        builder: (context,snapshot){
          snapshot.data.toString();

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height:15),
                Text(progressString),
                SizedBox(height:10),
                Text("Downloading..."),
              ],
            ),);
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              if(snapshot.data!.isEmpty){
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



              else{


               return StaggeredGridView.countBuilder(
                 padding: EdgeInsets.all(8),
                 itemCount: snapshot.data!.length,
                 shrinkWrap: true,
                 //controller: ref.watch(newsProvider).scrollController,
                 physics: const NeverScrollableScrollPhysics(),
                 staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                 crossAxisCount: 4,
                 mainAxisSpacing: 20,
                 crossAxisSpacing: 20,
                 itemBuilder: (context, index) {
                   print("This is the status of offline Status"+ snapshot.data![index].offlineStatus!);

                   if(snapshot.data!.isNotEmpty) {
                     print("New BASE64 Image");
                     print(snapshot.data![index].coverPhoto!);
                     return
                         InkWell(

                         // onTap: () => Get.to(() => WebViewNews(
                         //     newsUrl: allNews[index].url)),
                         onTap: () async{

                           hasInternet = await InternetConnectionChecker().hasConnection;
                           print("Downloaded Status "+snapshot.data![index].offlineStatus!);

                           if(hasInternet){
                             if(snapshot.data![index].offlineStatus! == 'not_downloaded'){
                               downloadFile(snapshot.data![index]!);
                             }
                           }

                           if(snapshot.data![index].offlineStatus! == 'downloaded'){
                             Navigator.push(context,
                               CupertinoPageRoute(
                                   builder: (BuildContext context){
                                     return  OfflinePlayerPage(savedItemModel: snapshot.data![index]);
                                   }
                               ),
                             );
                           }
                           //downloadFile(snapshot.data![index]!);

                     },
                   child: SavedItemCard(
                   snapshot.data![index].cid!,
                   snapshot.data![index].coverPhoto!,
                   snapshot.data![index].title!,
                   snapshot.data![index].type!,
                   snapshot.data![index].rating!,
                   snapshot.data![index].genres!,
                   snapshot.data![index].offlineStatus!
                   ),
                   );
                   }
                   else{
                     return SizedBox.shrink();
                   }
                 },
               );

                return Text(
                    snapshot.data.toString(),
                    style: const TextStyle(color: Colors.cyan, fontSize: 36)
                );
              }






            } else {
              return const Text('Empty data');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }


    }
    );
    
    
      Scaffold(
        backgroundColor: AppColors.thidasaDarkBlue,
        appBar: AppBar(
          backgroundColor: AppColors.thidasaBlue,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios_outlined),onPressed: (){
            Navigator.pop(context,true);
          },
          ),
          title: Text("Favourite Shows"),
        ),
        body:  Column(
          children: [
            SizedBox(height: 20,),

            Expanded(
              child: ScrollConfiguration(behavior: ScrollBehavior(),
                child: GlowingOverscrollIndicator(axisDirection: AxisDirection.down,
                  color: AppColors.thidasaBlue,
                  child: ListView(
                    children:  [
                      isCustomLoading==true ? Visibility(child: StaggeredGridView.countBuilder(
                        padding: EdgeInsets.all(8),
                        itemCount: 18,
                        shrinkWrap: true,
                        //controller: ref.watch(newsProvider).scrollController,
                        physics: const NeverScrollableScrollPhysics(),
                        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                        crossAxisCount: 4,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        itemBuilder: (context, index) {

                          if(true) {
                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.thidasaBlue,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 300,
                              child: ShimmerWidget.rectangular(height: 300,shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),),
                            )
                            ;
                          }
                          else{
                            return SizedBox.shrink();
                          }
                        },
                      ), maintainAnimation: true, maintainState: true,)
                      : favoriteItems.isNotEmpty? Visibility(child: StaggeredGridView.countBuilder(
                        padding: EdgeInsets.all(8),
                        itemCount: favoriteItems.length,
                        shrinkWrap: true,
                        //controller: ref.watch(newsProvider).scrollController,
                        physics: const NeverScrollableScrollPhysics(),
                        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                        crossAxisCount: 4,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        itemBuilder: (context, index) {

                          if(favoriteItems.isNotEmpty) {
                            return InkWell(
                              // onTap: () => Get.to(() => WebViewNews(
                              //     newsUrl: allNews[index].url)),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ViewPage(cid: favoriteItems[index].cid,type: favoriteItems[index].type,)));

                              },
                              child: ItemCard(
                                  favoriteItems[index].cid!,
                                  favoriteItems[index].coverPhoto!,
                                  favoriteItems[index].title!,
                                  favoriteItems[index].type!,
                                  favoriteItems[index].rating!,
                                  favoriteItems[index].genres!

                              ),
                            );
                          }
                          else{
                            return SizedBox.shrink();
                          }
                        },
                      ), maintainAnimation: true, maintainState: true,)
                      :Visibility(child: Center(
                        child: Column(
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
                        ),
                      ), maintainAnimation: true, maintainState: true, visible: favoriteItems.isEmpty,),

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
