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







class SavePage extends ConsumerStatefulWidget {
  const SavePage({Key? key}) : super(key: key);

  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends ConsumerState {
  TextEditingController searchController = TextEditingController();

  int _selectedIndex = 1;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
              (r) => false

      );
    }
    if (index == 1) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SavePage()),
              (r) => false

      );
    }
    if (index == 2) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
              (r) => false
      );
    }

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      //drawer: sideDrawer(newsController),
      appBar: customAppBar('Saved News', context, ),
      body:

      Center(
        child: isLoading
            ? CircularProgressIndicator()
            : savedItems.isEmpty
            ? Text(
          'No Saved Items',
          style: TextStyle(color: Colors.black87, fontSize: 24),
        )
        :savedItemsWidget(),
      ),


      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.burgundy,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.chat),
          //   label: 'Chats',
          // ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
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
