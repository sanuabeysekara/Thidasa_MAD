import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:news/constants/color_constants.dart';
import 'package:news/constants/size_constants.dart';
import 'package:news/constants/ui_constants.dart';
import 'package:news/controllers/news_controller.dart';
import 'package:news/db/saved_item_database.dart';
import 'package:news/models/saved_item_model.dart';
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

import '../models/articles_model.dart';
import '../providers/navigation_provider.dart';
import '../widgets/bottom_navigation_bar.dart';







class WatchLaterPage extends ConsumerStatefulWidget {
  const WatchLaterPage({Key? key}) : super(key: key);

  @override
  _WatchLaterPageState createState() => _WatchLaterPageState();
}

class _WatchLaterPageState extends ConsumerState {
  TextEditingController searchController = TextEditingController();


  late List<SavedItem> savedItems;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
   // SavedItemsDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.savedItems = await SavedItemsDatabase.instance.readAllItems();

    setState(() => isLoading = false);
  }


  @override
  Widget build(BuildContext context) {


    return Center(
      child: isLoading
          ? CircularProgressIndicator()
          : savedItems.isEmpty
          ? Text(
        'No Saved Items',
        style: TextStyle(color: Colors.black87, fontSize: 24),
      )
          :savedItemsWidget(),
    );
  }

  Widget savedItemsWidget2()=> ListView.builder(
      shrinkWrap: true,
      //controller: ref.watch(newsProvider).scrollController,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      //shrinkWrap: true,
      itemCount: savedItems.length,
      itemBuilder: (context, index) {

        if(index == savedItems.length){
          return
            ref.read(newsProvider).hasMore ?
            CupertinoActivityIndicator()   :
            Center(child: Text('No more Data'),);
        }
        if(savedItems[index].urlToImage != null && index < savedItems.length){
          return  InkWell(
            // onTap: () => Get.to(() => WebViewNews(
            //     newsUrl: allNews[index].url)),
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WebViewNews(newsUrl: savedItems[index].url)));

            },
            child: NewsCard(
                imgUrl: savedItems[index].urlToImage ??
                    '',
                desc: savedItems[index].description ??
                    '',
                title: savedItems[index].title,
                content:
                savedItems[index].content ??
                    '',
                postUrl: savedItems[index].url),
          );
        }


        else{
          return SizedBox.shrink();
        }



      }
  );

  Widget  savedItemsWidget() => StaggeredGridView.countBuilder(
    padding: EdgeInsets.all(8),
    itemCount: savedItems.length,
    staggeredTileBuilder: (index) => StaggeredTile.fit(2),
    crossAxisCount: 4,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    itemBuilder: (context, index) {
      final savedItem = savedItems[index];

      return  InkWell(
        // onTap: () => Get.to(() => WebViewNews(
        //     newsUrl: allNews[index].url)),
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WebViewNews(newsUrl: savedItems[index].url)));

        },
        child: SavedItemCard(
          id: savedItems[index].id!,
            imgUrl: savedItems[index].urlToImage ??
                '',
            desc: savedItems[index].description ??
                '',
            title: savedItems[index].title,
            content:
            savedItems[index].content ??
                '',
            postUrl: savedItems[index].url),
      );
    },
  );

}
