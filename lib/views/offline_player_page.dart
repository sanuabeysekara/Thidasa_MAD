
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:news/constants/color_constants.dart';
import 'package:news/constants/size_constants.dart';
import 'package:news/constants/ui_constants.dart';
import 'package:news/controllers/news_controller.dart';
import 'package:news/models/genres_model.dart';
import 'package:news/models/saved_item_model.dart';
import 'package:news/providers/genres_provider.dart';
import 'package:news/providers/http_provider.dart';
import 'package:news/providers/news_provider.dart';
import 'package:news/views/filter_page.dart';
import 'package:news/views/home_page.dart';
import 'package:news/views/settings_page.dart';
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
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constants/newsApi_constants.dart';
import '../models/articles_model.dart';
import '../models/item_model.dart';
import '../models/save_item_model.dart';
import '../providers/navigation_provider.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/genre_card.dart';
import '../widgets/item_card.dart';
import '../widgets/shimmer_widget.dart';
import 'dart:async';
import 'dart:io';

import '../widgets/video_player.dart';






class OfflinePlayerPage extends ConsumerStatefulWidget {

  final SavedItemModel savedItemModel;

  OfflinePlayerPage({Key? key, required this.savedItemModel}) : super(key: key);

  @override
  _OfflinePlayerPageState createState() => _OfflinePlayerPageState();


}

class _OfflinePlayerPageState extends ConsumerState<OfflinePlayerPage> {
  TextEditingController searchController = TextEditingController();

  late YoutubePlayerController _controller;
  String episode_number ="";

  late final File file;
  late VideoPlayerController controller;




  @override
  void initState() {
    file = File(widget.savedItemModel.offlinePath!);

    super.initState();
    // ref.read(genresProvider).isGenreLoading = true;
    // ref.read(genresProvider).getGenreItems();
    print(widget.savedItemModel.offlinePath!);
    controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {});
        controller.play();
      });

  }

  @override
  void dispose() {
    // SavedItemsDatabase.instance.close();
    controller?.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    List<ItemModel> searchedItems = ref.watch(httpProvider).searchedItems;
    print("Is Loading - " +ref.watch(genresPageProvider).isGenreLoading.toString());

    return Scaffold(
      backgroundColor: AppColors.thidasaDarkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.thidasaBlue,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_outlined),onPressed: (){
          Navigator.pop(context,true);
        },
        ),
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(10),
            //   child: Image.network(
            //     ThidasaApiConstants.imageBannerBaseURL + widget.banner ?? "",
            //     fit: BoxFit.fitHeight,
            //     height: 280,
            //     errorBuilder: (BuildContext context, Object exception,
            //         StackTrace? stackTrace) {
            //       return Card(
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(10)),
            //         child: const SizedBox(
            //           height: 200,
            //           width: double.infinity,
            //           child: Icon(Icons.broken_image_outlined),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Container(
              child: VideoPlayerWidget(controller:controller),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  //SizedBox(height: 150,),

                  Column(
                    children: [

                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.savedItemModel.title!,
                          style: const TextStyle(
                              fontSize: Sizes.dimen_36,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              overflow: TextOverflow.ellipsis
                          ),
                        ),
                      ),

                      SizedBox(height: 6,),
                      Row(
                        children: [
                          Icon(Icons.star_border,color: AppColors.thidasaLightBlue,),
                          SizedBox(width: 5,),
                          Text(
                            widget.savedItemModel.rating!,
                            style: const TextStyle(
                                fontSize: Sizes.dimen_20,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),

                      Text(widget.savedItemModel.description!,
                        style: const TextStyle(
                          fontSize: Sizes.dimen_18,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),


                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );

    // return YoutubePlayerBuilder(
    //     player: YoutubePlayer(
    //       controller: _controller,
    //       bottomActions: [
    //         CurrentPosition(),
    //         ProgressBar(
    //           isExpanded: true,
    //           colors: const ProgressBarColors(
    //             playedColor: AppColors.thidasaLightBlue,
    //             handleColor: AppColors.thidasaLightBlue,
    //             bufferedColor: AppColors.thidasaBlueLight,
    //             backgroundColor: AppColors.thidasaBlue,
    //           ),
    //
    //         ),
    //         PlaybackSpeedButton(),
    //         FullScreenButton(
    //
    //         )
    //       ],
    //     ),
    //     builder: (context,player){
    //       return Scaffold(
    //         backgroundColor: AppColors.thidasaDarkBlue,
    //         appBar: AppBar(
    //           backgroundColor: AppColors.thidasaBlue,
    //           leading: IconButton(icon: Icon(Icons.arrow_back_ios_outlined),onPressed: (){
    //             Navigator.pop(context,true);
    //           },
    //           ),
    //         ),
    //         body:  SingleChildScrollView(
    //           child: Column(
    //             children: [
    //               // ClipRRect(
    //               //   borderRadius: BorderRadius.circular(10),
    //               //   child: Image.network(
    //               //     ThidasaApiConstants.imageBannerBaseURL + widget.banner ?? "",
    //               //     fit: BoxFit.fitHeight,
    //               //     height: 280,
    //               //     errorBuilder: (BuildContext context, Object exception,
    //               //         StackTrace? stackTrace) {
    //               //       return Card(
    //               //         shape: RoundedRectangleBorder(
    //               //             borderRadius: BorderRadius.circular(10)),
    //               //         child: const SizedBox(
    //               //           height: 200,
    //               //           width: double.infinity,
    //               //           child: Icon(Icons.broken_image_outlined),
    //               //         ),
    //               //       );
    //               //     },
    //               //   ),
    //               // ),
    //               Container(
    //                 child: player,
    //               ),
    //               Container(
    //                 padding: EdgeInsets.all(20),
    //                 child: Column(
    //                   children: [
    //                     //SizedBox(height: 150,),
    //
    //                     Column(
    //                       children: [
    //
    //                         Container(
    //                           alignment: Alignment.topLeft,
    //                           child: Text(
    //                             "",
    //                             style: const TextStyle(
    //                                 fontSize: Sizes.dimen_36,
    //                                 color: Colors.white,
    //                                 fontWeight: FontWeight.w300,
    //                                 overflow: TextOverflow.ellipsis
    //                             ),
    //                           ),
    //                         ),
    //
    //                         SizedBox(height: 6,),
    //                         Row(
    //                           children: [
    //                             Icon(Icons.star_border,color: AppColors.thidasaLightBlue,),
    //                             SizedBox(width: 5,),
    //                             Text(
    //                               "",
    //                               style: const TextStyle(
    //                                   fontSize: Sizes.dimen_20,
    //                                   color: Colors.white,
    //                                   fontWeight: FontWeight.normal,
    //                                   overflow: TextOverflow.ellipsis
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                         SizedBox(height: 20,),
    //
    //                         Text("",
    //                           style: const TextStyle(
    //                             fontSize: Sizes.dimen_18,
    //                             color: Colors.white,
    //                             fontWeight: FontWeight.w300,
    //                           ),
    //                         ),
    //
    //
    //                       ],
    //                     )
    //                   ],
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //       );
    //     }
    // );


  }



}
