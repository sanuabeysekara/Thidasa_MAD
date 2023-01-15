import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:news/constants/color_constants.dart';
import 'package:news/constants/size_constants.dart';
import 'package:news/constants/ui_constants.dart';
import 'package:news/controllers/news_controller.dart';
import 'package:news/models/genres_model.dart';
import 'package:news/models/saved_item_model.dart';
import 'package:news/providers/genres_provider.dart';
import 'package:news/providers/news_provider.dart';
import 'package:news/views/filter_page.dart';
import 'package:news/views/home_page.dart';
import 'package:news/views/search_results_page.dart';
import 'package:news/views/settings_page.dart';
import 'package:news/views/sort_results_page.dart';
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

import '../models/articles_model.dart';
import '../providers/http_provider.dart';
import '../providers/navigation_provider.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/genre_card.dart';
import '../widgets/shimmer_widget.dart';







class SearchPage extends ConsumerStatefulWidget {
   SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();


}

class _SearchPageState extends ConsumerState<SearchPage> {
  TextEditingController searchController = TextEditingController();
  String searchValue ="";
  late List<SavedItem> savedItems;

  @override
  void initState() {
    super.initState();
    // ref.read(genresProvider).isGenreLoading = true;
    // ref.read(genresProvider).getGenreItems();

  }

  @override
  void dispose() {
   // SavedItemsDatabase.instance.close();

    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    List<GenreModel> genres = ref.watch(genresPageProvider).allGenres;
    print("Is Loading - " +ref.watch(genresPageProvider).isGenreLoading.toString());
    return
      Column(
        children: [
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.all(10),
            child: Container(
                decoration: BoxDecoration(
                  color: AppColors.thidasaBlue,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2, color: AppColors.thidasaLightBlue),
                ),
                child:  Row(
                  children: [
                    SizedBox(width: 10,),
                    Expanded(child: TextField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      decoration: const InputDecoration(

                        hintText: "What are you looking for?",
                        border: InputBorder.none,
                      ),
                      onChanged: (val) {
                        setState(() {
                          searchValue = val;
                        });
                      },
                      onSubmitted: (value) async {
                        if(searchValue.isNotEmpty){
                          ref.read(httpProvider).getSearchedItems(searchValue);
                          Navigator.push(context,
                            CupertinoPageRoute(
                                builder: (BuildContext context){
                                  return  SearchResultsPage(keyword: searchValue,);
                                }
                            ),
                          );

                        }
                        else
                        {

                        }
                      },
                    )),
                    IconButton(onPressed: (){
                      if(searchValue.isNotEmpty){
                        ref.read(httpProvider).getSearchedItems(searchValue);
                        Navigator.push(context,
                          CupertinoPageRoute(
                              builder: (BuildContext context){
                                return  SearchResultsPage(keyword: searchValue,);
                              }
                          ),
                        );

                      }
                      else
                      {

                      }
                    }, icon: Icon(Icons.search_rounded,color: AppColors.thidasaLightBlue,),)
                  ],
                )
            ),
          ),

          Expanded(
            child: ScrollConfiguration(behavior: ScrollBehavior(),
              child: GlowingOverscrollIndicator(axisDirection: AxisDirection.down,
                color: AppColors.thidasaBlue,
                child: ListView(
                  children:  [
                    Visibility(child: StaggeredGridView.countBuilder(
                      padding: EdgeInsets.all(8),
                      itemCount: genres.length,
                      shrinkWrap: true,
                      //controller: ref.watch(newsProvider).scrollController,
                      physics: const NeverScrollableScrollPhysics(),
                      staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                      crossAxisCount: 4,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      itemBuilder: (context, index) {

                        if(genres.isNotEmpty) {
                          return InkWell(
                            // onTap: () => Get.to(() => WebViewNews(
                            //     newsUrl: allNews[index].url)),
                            onTap: () {
                              if(genres[index].genreId!.isNotEmpty){
                                ref.read(httpProvider).getSortedItems(genres[index].genreId!);
                                Navigator.push(context,
                                  CupertinoPageRoute(
                                      builder: (BuildContext context){
                                        return  SortResultsPage(keyword: genres[index].genreName!,);
                                      }
                                  ),
                                );

                              }
                              else
                              {

                              }
                            },
                            child: GenreCard(
                                genres[index].genreId!,
                                genres[index].genreName!,
                                genres[index].genreImage!

                            ),
                          );
                        }
                        else{
                          return SizedBox.shrink();
                        }
                      },
                    ), maintainAnimation: true, maintainState: true,visible: !ref.read(genresPageProvider).isGenreLoading,),
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

                        if(genres.isNotEmpty) {
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
                    ), maintainAnimation: true, maintainState: true, visible: ref.read(genresPageProvider).isGenreLoading,),

                  ],
                ),
              ),
            ),
          ),
        ],
      );



  }



}
