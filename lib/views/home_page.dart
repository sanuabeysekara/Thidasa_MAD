import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:news/constants/color_constants.dart';
import 'package:news/constants/size_constants.dart';
import 'package:news/constants/ui_constants.dart';
import 'package:news/controllers/news_controller.dart';
import 'package:news/providers/news_provider.dart';
import 'package:news/views/filter_page.dart';
import 'package:news/views/save_page.dart';
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

import '../models/articles_model.dart';
import '../providers/navigation_provider.dart';
class HomePage extends ConsumerStatefulWidget  {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}




class _HomePageState extends ConsumerState  {

  TextEditingController searchController = TextEditingController();


  int _selectedIndex = 0;

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
    List<ArticleModel> allNews = ref.watch(newsProvider).allNews;
    List<ArticleModel> breakingNews = ref.watch(newsProvider).breakingNews;

    return Scaffold(
      //drawer: sideDrawer(newsController),
      appBar: customAppBar('News', context, actions: [
        IconButton(
          onPressed: () {
            ref.read(newsProvider).reset();
          },
          icon: const Icon(Icons.refresh),
        ),
      ]),
      body: SingleChildScrollView(
        controller: ref.watch(newsProvider).scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.dimen_8),
                margin: const EdgeInsets.symmetric(
                    horizontal: Sizes.dimen_18, vertical: Sizes.dimen_16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Sizes.dimen_8)),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(left: Sizes.dimen_16),
                        child: TextField(
                          controller: searchController,
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search News"),
                          onChanged: (val) {
                            ref.read(newsProvider).searchNews = val;
                            ref.read(newsProvider).notifyListeners();
                          },
                          onSubmitted: (value) async {
                            ref.read(newsProvider).searchNews = value;
                            ref.read(newsProvider).getAllNews(
                                searchKey: ref.read(newsProvider).searchNews);
                            searchController.clear();
                            const snackBar = SnackBar(
                              content: Text('Searching...'),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          color: AppColors.burgundy,
                          onPressed: () async {
                            ref.read(newsProvider).getAllNews(
                                searchKey: ref.read(newsProvider).searchNews);
                            searchController.clear();
                          },
                          icon: const Icon(Icons.search_sharp)),
                    ),
                  ],
                ),
              ),
            ),

         CarouselSlider(
          options: CarouselOptions(
              height: 200, autoPlay: true, enlargeCenterPage: true),
          items: breakingNews.map((instance) {
            return ref.read(newsProvider).articleNotFound
                ? const Center(
                    child: Text("Not Found",
                        style: TextStyle(fontSize: 30)))
                : breakingNews.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : Builder(builder: (BuildContext context) {
                        try {
                          return Banner(
                            location: BannerLocation.topStart,
                            message: 'Headlines',
                            child: InkWell(

                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => WebViewNews(newsUrl: instance.url)));

                              },
                              child: Stack(children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  child: Image.network(
                                    instance.urlToImage ?? " ",
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
                                                Colors.black12
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
                                                  horizontal: 10),
                                              child: Text(
                                                instance.title,
                                                style: const TextStyle(
                                                    fontSize: Sizes
                                                        .dimen_16,
                                                    color:
                                                        Colors.white,
                                                    fontWeight:
                                                        FontWeight
                                                            .bold),
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
        ),

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
          ListView.builder(
             shrinkWrap: true,
              //controller: ref.watch(newsProvider).scrollController,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              //shrinkWrap: true,
              itemCount: allNews.length+1,
              itemBuilder: (context, index) {

                if(index == allNews.length){
                return 
                  ref.read(newsProvider).hasMore ?
                  CupertinoActivityIndicator()   :
                  Center(child: Text('No more Data'),);
                }
                if(allNews[index].urlToImage != null && index < allNews.length){
                        return  InkWell(
                          // onTap: () => Get.to(() => WebViewNews(
                          //     newsUrl: allNews[index].url)),
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WebViewNews(newsUrl: allNews[index].url)));

                          },
                          child: NewsCard(
                              imgUrl: allNews[index].urlToImage ??
                                  '',
                              desc: allNews[index].description ??
                                  '',
                              title: allNews[index].title,
                              content:
                              allNews[index].content ??
                                  '',
                              postUrl: allNews[index].url),
                        );
                }


                else{
                  return SizedBox.shrink();
                }



              }
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FilterPage()),
          );
        },
        backgroundColor: AppColors.burgundy,
        child: const Icon(Icons.filter_alt_outlined),
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
}
