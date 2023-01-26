import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:news/constants/color_constants.dart';
import 'package:news/constants/newsApi_constants.dart';
import 'package:news/constants/size_constants.dart';
import 'package:news/constants/ui_constants.dart';
import 'package:news/controllers/news_controller.dart';
import 'package:news/models/genres_model.dart';
import 'package:news/models/item_model.dart';
import 'package:news/providers/genres_provider.dart';
import 'package:news/providers/news_provider.dart';
import 'package:news/providers/items_provider.dart';
import 'package:news/views/filter_page.dart';
import 'package:news/views/save_page.dart';
import 'package:news/views/settings_page.dart';
import 'package:news/views/view_page.dart';
import 'package:news/views/web_view_news.dart';
import 'package:news/views/your_page.dart';
import 'package:news/widgets/custom_appBar.dart';
import 'package:news/widgets/item_card.dart';
import 'package:news/widgets/news_card.dart';
//import 'package:news/widgets/side_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/widgets/shimmer_widget.dart';
import 'package:news/widgets/trending_list_genres.dart';

import '../models/articles_model.dart';
import '../providers/navigation_provider.dart';
import '../widgets/bottom_navigation_bar.dart';
class HomePage extends ConsumerStatefulWidget  {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState  {

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<ArticleModel> allNews = ref.watch(newsProvider).allNews;
    List<ArticleModel> breakingNews = ref.watch(newsProvider).breakingNews;
    List<ItemModel> trendingList = ref.watch(itemsProvider).trendingItems;
    List<ItemModel> latestList = ref.watch(itemsProvider).latestItems;
    List<GenreModel> genres = ref.watch(genresProvider).allGenres;

    return RefreshIndicator(child: SingleChildScrollView(
          controller: ref.watch(newsProvider).scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40,),
              Visibility(child: CarouselSlider(
                options: CarouselOptions(
                    aspectRatio: 16/9, height: 270, autoPlay: true, enlargeCenterPage: true),
                items: [
                  ShimmerWidget.rectangular(height: 200,shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),),
                  ShimmerWidget.rectangular(height: 200,shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),),
                  ShimmerWidget.rectangular(height: 200,shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),),
                ],
              ), maintainAnimation: true, maintainState: true, visible: ref.read(itemsProvider).isLoading,),
              Visibility(child: CarouselSlider(
                options: CarouselOptions(
                    aspectRatio: 16/9, height: 250, autoPlay: true, enlargeCenterPage: true),
                items: trendingList.map((instance) {
                  return false
                      ? const Center(
                      child: Text("Not Found",
                          style: TextStyle(fontSize: 30)))
                      : trendingList.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : Builder(builder: (BuildContext context) {
                    try {
                      return Container(

                        child: InkWell(

                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ViewPage(cid: instance.cid,type: instance.type,)));

                          },
                          child: Stack(children: [
                            ClipRRect(
                              borderRadius:
                              BorderRadius.circular(10),
                              child: Image.network(
                                ThidasaApiConstants.imageHomeBaseURL+instance.basePhoto! ?? " ",
                                fit: BoxFit.fill,
                                height: double.infinity,
                                width: double.infinity,
                                errorBuilder:
                                    (BuildContext context,
                                    Object exception,
                                    StackTrace? stackTrace) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            10)),
                                    child: const SizedBox(
                                      height: 200,
                                      width: double.infinity,
                                      child: Icon(Icons
                                          .broken_image_outlined),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                          10),
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.black87
                                                .withOpacity(0),
                                            Colors.black
                                          ],
                                          begin:
                                          Alignment.topCenter,
                                          end: Alignment
                                              .bottomCenter)),
                                  child: Container(
                                      padding: const EdgeInsets
                                          .symmetric(
                                          horizontal: 5,
                                          vertical: 10),
                                      child: Container(
                                          margin: const EdgeInsets
                                              .symmetric(
                                              horizontal: 10, vertical: 20),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                instance.title!,
                                                style: const TextStyle(
                                                  fontSize: Sizes
                                                      .dimen_22,
                                                  color:
                                                  Colors.white,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold,
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              Row(children: [

                                                for ( var i in genres ) TrendingGenresWidget(i,instance.genres!),

                                              ],)

                                            ],
                                          ))),
                                )),
                          ]),
                        ),
                      );
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                      return Container();
                    }
                  });
                }).toList(),
              ), maintainAnimation: true, maintainState: true,visible: ref.read(itemsProvider).isLoading?false:true,),


              vertical10,
              const Divider(),
              vertical10,
              ref.watch(newsProvider).cName.isNotEmpty
                  ? Padding(
                padding: const EdgeInsets.only(left: Sizes.dimen_18),
                child: Obx(() {
                  return Text(
                    ref.watch(newsProvider).cName.toUpperCase(),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: Sizes.dimen_20,
                        fontWeight: FontWeight.bold),
                  );
                }),
              )
                  : const SizedBox.shrink(),
              vertical10,
              Container(
                margin: EdgeInsets.only(left: 10),
                child:
                Row(
                  children: [
                    Icon(Icons.local_fire_department,color: AppColors.thidasaLightBlue,size: 30,),
                    horizontal15,
                    Text(
                      "Latest",
                      style: const TextStyle(
                        fontSize: Sizes
                            .dimen_32,
                        color:
                        Colors.white,
                        fontWeight:
                        FontWeight
                            .bold,
                      ),
                    )
                  ],
                ),

              ),
              vertical10,


              Visibility(child: StaggeredGridView.countBuilder(
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

                  if(latestList.isNotEmpty) {
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
              ), maintainAnimation: true, maintainState: true, visible: ref.read(itemsProvider).isLatestItemsLoading,),
              Visibility(child: StaggeredGridView.countBuilder(
                padding: EdgeInsets.all(8),
                itemCount: latestList.length,
                shrinkWrap: true,
                //controller: ref.watch(newsProvider).scrollController,
                physics: const NeverScrollableScrollPhysics(),
                staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                crossAxisCount: 4,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                itemBuilder: (context, index) {

                  if(latestList.isNotEmpty) {
                    return InkWell(

                      // onTap: () => Get.to(() => WebViewNews(
                      //     newsUrl: allNews[index].url)),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ViewPage(cid: latestList[index].cid,type: latestList[index].type,)));

                      },
                      child: ItemCard(
                          latestList[index].cid!,
                          latestList[index].coverPhoto!,
                          latestList[index].title!,
                          latestList[index].type!,
                          latestList[index].rating!,
                          latestList[index].genres!

                      ),
                    );
                  }
                  else{
                    return SizedBox.shrink();
                  }
                },
              ), maintainAnimation: true, maintainState: true,visible: ref.read(itemsProvider).isLatestItemsLoading?false:true,)


            ],
          ),
        ), onRefresh: ()async{
      ref.read(itemsProvider).refresh();
    });
  }

}

// SingleChildScrollView(
// controller: ref.watch(newsProvider).scrollController,
// keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
// physics: const BouncingScrollPhysics(),
// child: Column(
// mainAxisSize: MainAxisSize.min,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// SizedBox(height: 40,),
//
// CarouselSlider(
// options: CarouselOptions(
// aspectRatio: 16/9, height: 270, autoPlay: true, enlargeCenterPage: true),
// items: [
// ShimmerWidget.rectangular(height: 200,shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),),
// ShimmerWidget.rectangular(height: 200,shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),),
// ShimmerWidget.rectangular(height: 200,shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),),
// ],
// ),
//
// vertical10,
// const Divider(),
// vertical10,
// ref.watch(newsProvider).cName.isNotEmpty
// ? Padding(
// padding: const EdgeInsets.only(left: Sizes.dimen_18),
// child: Obx(() {
// return Text(
// ref.watch(newsProvider).cName.toUpperCase(),
// textAlign: TextAlign.start,
// style: const TextStyle(
// fontSize: Sizes.dimen_20,
// fontWeight: FontWeight.bold),
// );
// }),
// )
// : const SizedBox.shrink(),
// vertical10,
// StaggeredGridView.countBuilder(
// padding: EdgeInsets.all(8),
// itemCount: latestList.length,
// shrinkWrap: true,
// //controller: ref.watch(newsProvider).scrollController,
// physics: const NeverScrollableScrollPhysics(),
// staggeredTileBuilder: (index) => StaggeredTile.fit(2),
// crossAxisCount: 4,
// mainAxisSpacing: 4,
// crossAxisSpacing: 4,
// itemBuilder: (context, index) {
//
// if(latestList.isNotEmpty) {
// return InkWell(
// // onTap: () => Get.to(() => WebViewNews(
// //     newsUrl: allNews[index].url)),
// onTap: () {
// Navigator.push(
// context,
// MaterialPageRoute(builder: (context) =>
// WebViewNews(newsUrl: latestList[index].cid!)));
// },
// child: ItemCard(
// latestList[index].cid!,
// latestList[index].coverPhoto!,
// latestList[index].title!,
// latestList[index].type!,
// latestList[index].genres!
//
// ),
// );
// }
// else{
// return SizedBox.shrink();
// }
// },
// ),
// ],
// ),
// ),