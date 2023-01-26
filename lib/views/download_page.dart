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
import '../providers/download_provider.dart';
import '../providers/navigation_provider.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/genre_card.dart';
import '../widgets/item_card.dart';
import '../widgets/shimmer_widget.dart';

import 'package:lottie/lottie.dart';






class DownloadPage extends ConsumerStatefulWidget {
  DownloadPage({Key? key}) : super(key: key);

  @override
  _DownloadPageState createState() => _DownloadPageState();



}

class _DownloadPageState extends ConsumerState<DownloadPage> {
  TextEditingController searchController = TextEditingController();
  late List<ItemModel> favoriteItems;
  bool isCustomLoading = false;
  bool downloading = false;
  var progressString = "";
  bool hasInternet = false;
  bool isDownloadOnProgress = false;
  Future<List<SavedItemModel>> savedItemsList = SavedItemsDatabase.instance.readAllItems();

  int progress = 0;
  int downloadStatus = 0;
  String downloadItemName = "Initializing";
  String downloadTaskId = "Initializing";
  late final tasks;



  final ReceivePort _port = ReceivePort();

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);

  }



  @override
  void initState() {
    super.initState();
    isDownloadOnProgress = false;
    ref.read(downloadProvider).resetIfNotDownloading();
    print("Download Widget Tree "+ref.read(downloadProvider).isDownloading.toString());
    //ref.read(downloadProvider).redirectIfDownloading();

    // ref.read(genresProvider).isGenreLoading = true;
    // ref.read(genresProvider).getGenreItems();
    Future<List<SavedItemModel>> savedItemsList = SavedItemsDatabase.instance.readAllItems();

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      ref.read(downloadProvider).isDownloading = true;
      ref.read(downloadProvider).downloadID = data[0];
      ref.read(downloadProvider).downloadStatus = data[1].value;
      ref.read(downloadProvider).downloadProgress = data[2];
      ref.read(downloadProvider).updateData();
      if(data[1].value == 3 || data[1].value == 4 || data[1].value == 5 ||data[1].value == 6){
        ref.read(downloadProvider).reset();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => super.widget));
      }

      print("provider's progess"+ref.read(downloadProvider).downloadProgress.toString());

      // setState((){
      //   isDownloadOnProgress = true;
      // });
    });

    FlutterDownloader.registerCallback(downloadCallback,step: 1);



  }

  @override
  void dispose() {
    //DBHelper.instance.close();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    print("Download Dispose was called");
    super.dispose();
  }


  Future<void> downloadFile(SavedItemModel saveditem) async {
    // Dio dio = Dio();
    // String myURL ="";
    // String OriginURL = saveditem.link??"";
    // try {
    //   var dir = await getApplicationDocumentsDirectory();
    //   print("path ${dir.path}");
    //   myURL = "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4";
    //   print("My URL"+myURL);
    //   await dio.download(OriginURL, myURL,
    //       onReceiveProgress: (rec, total) {
    //         print("Rec: $rec , Total: $total");
    //
    //         setState(() {
    //           downloading = true;
    //           progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
    //         });
    //       });
    // } catch (e) {
    //   print(e);
    // }
    //
    // SavedItemModel updatedSavedItem = saveditem.copyWith(
    //   offlineStatus: "downloaded",
    //   offlinePath: myURL,
    // );
    //
    // await SavedItemsDatabase.instance.update(updatedSavedItem);
    // print("Updated Saved Item "+updatedSavedItem!.id!.toString());
    //
    // SavedItemModel newSavedItem = await SavedItemsDatabase.instance.readItem(updatedSavedItem.id!);
    //
    // print("BASE64 Image");
    // print(newSavedItem.coverPhoto);
    //
    // setState(() {
    //   downloading = false;
    //   progressString = "Completed";
    // });
    // print("Download completed");



    final status = await Permission.storage.request();
    String OriginURL = saveditem.link??"";

    if (status.isGranted) {
      var dir = await getApplicationDocumentsDirectory();
      String myURL ="";
      var saveToDir = dir.path;
      var myFileName = "${saveditem.title}_${DateTime.now().millisecondsSinceEpoch}.mp4";
      myURL = "${dir.path}/${myFileName}";
      ref.read(downloadProvider).downloadFileName = saveditem.title!;
      ref.read(downloadProvider).savedItemsDbID = saveditem.id!;

      final id = await FlutterDownloader.enqueue(
        url:OriginURL,
        savedDir: saveToDir,
        fileName: myFileName,
        showNotification: true,
        openFileFromNotification: false,
      );

      SavedItemModel updatedSavedItem = saveditem.copyWith(
        offlineStatus: "downloaded",
        offlinePath: myURL,
      );

      await SavedItemsDatabase.instance.update(updatedSavedItem);
      print("Updated Saved Item "+updatedSavedItem!.id!.toString());

      SavedItemModel newSavedItem = await SavedItemsDatabase.instance.readItem(updatedSavedItem.id!);

    } else {
      print("Permission deined");
    }


  }


  @override
  Widget build(BuildContext context) {
    ref.read(downloadProvider).updateData();
    print("Download Widget Tree is Building");
    print("Is DOwnloading"+ref.watch(downloadProvider).isDownloading.toString());
    return Scaffold(
      backgroundColor: AppColors.thidasaDarkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.thidasaBlue,
        title: Text("My Downloads"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body:
      (ref.watch(downloadProvider).isDownloading)==false?FutureBuilder(
          future: savedItemsList,
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


                  return ScrollConfiguration(behavior: ScrollBehavior(),
                      child: GlowingOverscrollIndicator(axisDirection: AxisDirection.down,
                          color: AppColors.thidasaBlue,
                          child:SingleChildScrollView(
                            child: StaggeredGridView.countBuilder(
                              padding: EdgeInsets.all(8),
                              itemCount: snapshot.data!.length,
                              shrinkWrap: true,
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
                            ),
                          )
                      ));



                }






              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }


          }
      )
          :Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset("assets/images/downloading_animation.json"),
              SizedBox(height: 30,),
              Container(padding: EdgeInsets.all(10),
                child: LinearProgressIndicator(
                  value: ref.read(downloadProvider).downloadProgress.toDouble()/100,
                ),
              ),
              SizedBox(height: 10,),
              Text(ref.read(downloadProvider).downloadFileName+" ",style: TextStyle(fontSize: Sizes.dimen_16),),
              SizedBox(height: 5,),
              Text(ref.read(downloadProvider).downloadProgress.toString()+"%",style: TextStyle(fontSize: Sizes.dimen_26),),
              ElevatedButton(onPressed: () async {
                if(await ref.read(downloadProvider).cancel()){
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => super.widget));
                }
              }, child: Text("Cancel"))
            ],
          ),
        ),
      ),
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
