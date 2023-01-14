import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:news/constants/color_constants.dart';
import 'package:news/constants/size_constants.dart';
import 'package:news/constants/ui_constants.dart';
import 'package:news/controllers/news_controller.dart';
import 'package:news/db/saved_item_database.dart';
import 'package:news/models/genres_model.dart';
import 'package:news/models/saved_item_model.dart';
import 'package:news/providers/genres_provider.dart';
import 'package:news/providers/http_provider.dart';
import 'package:news/providers/news_provider.dart';
import 'package:news/views/filter_page.dart';
import 'package:news/views/home_page.dart';
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

import '../models/articles_model.dart';
import '../models/item_model.dart';
import '../providers/navigation_provider.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/genre_card.dart';
import '../widgets/item_card.dart';
import '../widgets/shimmer_widget.dart';







class SortResultsPage extends ConsumerStatefulWidget {
  final String keyword;
  SortResultsPage({Key? key, required this.keyword}) : super(key: key);

  @override
  _SortResultsPageState createState() => _SortResultsPageState();


}

class _SortResultsPageState extends ConsumerState<SortResultsPage> {
  TextEditingController searchController = TextEditingController();

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
    List<ItemModel> searchedItems = ref.watch(httpProvider).searchedItems;
    print("Is Loading - " +ref.watch(genresPageProvider).isGenreLoading.toString());
    return
    Scaffold(
      backgroundColor: AppColors.thidasaDarkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.thidasaBlue,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_outlined),onPressed: (){
        Navigator.pop(context,true);
      },
      ),
        title: Text("Results for \""+widget.keyword+"\""),
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

                        if(searchedItems.isNotEmpty) {
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
                    ), maintainAnimation: true, maintainState: true, visible: ref.read(httpProvider).isSearchedItemsLoading,),
                    Visibility(child: StaggeredGridView.countBuilder(
                      padding: EdgeInsets.all(8),
                      itemCount: searchedItems.length,
                      shrinkWrap: true,
                      //controller: ref.watch(newsProvider).scrollController,
                      physics: const NeverScrollableScrollPhysics(),
                      staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                      crossAxisCount: 4,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      itemBuilder: (context, index) {

                        if(searchedItems.isNotEmpty) {
                          return InkWell(
                            // onTap: () => Get.to(() => WebViewNews(
                            //     newsUrl: allNews[index].url)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ViewPage(cid: searchedItems[index].cid,type: searchedItems[index].type,)));

                            },
                            child: ItemCard(
                                searchedItems[index].cid!,
                                searchedItems[index].coverPhoto!,
                                searchedItems[index].title!,
                                searchedItems[index].type!,
                                searchedItems[index].rating!,
                                searchedItems[index].genres!

                            ),
                          );
                        }
                        else{
                          return SizedBox.shrink();
                        }
                      },
                    ), maintainAnimation: true, maintainState: true,visible: !ref.read(httpProvider).isSearchedItemsLoading,),
                    Visibility(child:
                    Center(
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
                    ), maintainAnimation: true, maintainState: true, visible: ref.read(httpProvider).itemNotFound,),

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
