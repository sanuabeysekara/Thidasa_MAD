import 'package:carousel_slider/carousel_slider.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:news/constants/color_constants.dart';
import 'package:news/constants/newsApi_constants.dart';
import 'package:news/constants/size_constants.dart';
import 'package:news/constants/ui_constants.dart';
import 'package:news/controllers/news_controller.dart';
import 'package:news/db/saved_item_database.dart';
import 'package:news/models/genres_model.dart';
import 'package:news/models/item_details_torrent_movie_model.dart';
import 'package:news/models/item_details_tv_series_model.dart';
import 'package:news/models/item_model.dart';
import 'package:news/models/review_model.dart';
import 'package:news/models/saved_item_model.dart';
import 'package:news/models/tv_series_model.dart';
import 'package:news/providers/genres_provider.dart';
import 'package:news/providers/item_details_provider.dart';
import 'package:news/providers/news_provider.dart';
import 'package:news/utils/shared_preferences.dart';
import 'package:news/views/filter_page.dart';
import 'package:news/views/home_page.dart';
import 'package:news/views/player_page.dart';
import 'package:news/views/review_page.dart';
import 'package:news/views/search_results_page.dart';
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
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/articles_model.dart';
import '../models/server_response_model.dart';
import '../providers/http_provider.dart';
import '../providers/navigation_provider.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/details_genres.dart';
import '../widgets/genre_card.dart';
import '../widgets/shimmer_widget.dart';
import 'package:intl/intl.dart';

class ViewPage extends ConsumerStatefulWidget {
  final cid;
  final type;
  ViewPage({Key? key, required this.cid, required this.type}) : super(key: key);

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends ConsumerState<ViewPage> {
  late Flushbar flush;
  bool actionButtonVisibility = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print("Is Loading - " +ref.watch(genresPageProvider).isGenreLoading.toString());
    return Scaffold(
      backgroundColor: AppColors.thidasaDarkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.thidasaBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: (buildItemDetails()),
    );
  }

  Widget buildItemDetails() {
    print("Build Items was callled");

    switch (widget.type) {
      case "tvseries":
        return tvSeries();
        break;
      case "torrent_movies":
        return torrentMovie();
        break;
      case "online_movies":
        return Container();
        break;
      case "interviews":
        return Container();
        break;
      case "live_stream":
        return Container();
        break;
      default:
        return Container();
    }
  }

  Widget tvSeries() {
    return FutureBuilder(
      future: ref.read(itemDetailsProvider).getTVSeriesDetails(widget.cid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ItemDetailsTvSeries itemDetailsTvSeries = snapshot.data!;
          ItemModel itemData = itemDetailsTvSeries.itemData ?? ItemModel();
          String coverPhoto = itemData.bannerPhoto ?? "";
          String photo = itemData.coverPhoto ?? "";

          String title = itemData.title ?? "";

          print(ThidasaApiConstants.imageBannerBaseURL + coverPhoto);
          return Container(
            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  ThidasaApiConstants.imageBannerBaseURL + coverPhoto ?? "",
                  fit: BoxFit.fitHeight,
                  height: 280,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: const SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Icon(Icons.broken_image_outlined),
                      ),
                    );
                  },
                ),
              ),
              ScrollConfiguration(
                behavior: ScrollBehavior(),
                child: GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    color: AppColors.thidasaBlue,
                    child: ListView(
                      children: [
                        Positioned(
                          height: 120,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Stack(
                            children: [
                              Container(
                                height: 450,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    gradient: LinearGradient(
                                        colors: [
                                          AppColors.thidasaDarkBlue
                                              .withOpacity(0.500),
                                          AppColors.thidasaDarkBlue
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.center)),
                              ),
                              Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    height: 350,
                                    padding: EdgeInsets.only(left: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 120,
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            ThidasaApiConstants
                                                    .imageCardBaseURL +
                                                photo,
                                            fit: BoxFit.fitWidth,
                                            width: 160,
                                            errorBuilder: (BuildContext context,
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
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    alignment: Alignment.topLeft,
                                    padding:
                                        EdgeInsets.only(left: 20, right: 10),
                                    color: AppColors.thidasaDarkBlue,
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                title,
                                                style: const TextStyle(
                                                    fontSize: Sizes.dimen_36,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              )),
                                              SizedBox(width: 12),
                                              UserSharedPreferences
                                                          .getToken() !=
                                                      null
                                                  ? FavoriteButton(
                                                      isFavorite:
                                                          itemDetailsTvSeries
                                                              .is_already_wishlisted!,
                                                      iconColor: AppColors
                                                          .thidasaLightBlue,
                                                      iconSize: 50,
                                                      valueChanged:
                                                          (_isFavorite) async {
                                                        var map = new Map<
                                                            String, dynamic>();
                                                        map['cid'] =
                                                            itemData.cid;
                                                        map['uid'] =
                                                            UserSharedPreferences
                                                                .getID();
                                                        if (_isFavorite) {
                                                          bool
                                                              _wasButtonClicked;
                                                          ServerResponse
                                                              serverResponse =
                                                              await ref
                                                                  .read(
                                                                      httpProvider)
                                                                  .addToWishList(
                                                                      map);
                                                          if (serverResponse
                                                                  .code ==
                                                              200) {
                                                            flush = Flushbar<
                                                                bool>(
                                                              title:
                                                                  "Added to Wishlist ",
                                                              message:
                                                                  "The item added to wishlist",
                                                              flushbarPosition:
                                                                  FlushbarPosition
                                                                      .TOP,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          6),
                                                              backgroundColor:
                                                                  Colors.green
                                                                      .shade600,
                                                              icon: Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              mainButton:
                                                                  TextButton(
                                                                onPressed: () {
                                                                  flush.dismiss(
                                                                      true); // result = true
                                                                },
                                                                child: Text(
                                                                  "OK",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ) // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
                                                              ..show(context)
                                                                  .then(
                                                                      (result) {
                                                                setState(() {
                                                                  // setState() is optional here
                                                                  _wasButtonClicked =
                                                                      result;
                                                                });
                                                              });
                                                          }
                                                        } else {
                                                          bool
                                                              _wasButtonClicked;
                                                          ServerResponse
                                                              serverResponse =
                                                              await ref
                                                                  .read(
                                                                      httpProvider)
                                                                  .removeFromWishList(
                                                                      map);
                                                          if (serverResponse
                                                                  .code ==
                                                              200) {
                                                            flush = Flushbar<
                                                                bool>(
                                                              title:
                                                                  "Removed from Wishlist ",
                                                              message:
                                                                  "The item was removed from wishlist",
                                                              flushbarPosition:
                                                                  FlushbarPosition
                                                                      .TOP,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          6),
                                                              backgroundColor:
                                                                  Colors.green
                                                                      .shade600,
                                                              icon: Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              mainButton:
                                                                  TextButton(
                                                                onPressed: () {
                                                                  flush.dismiss(
                                                                      true); // result = true
                                                                },
                                                                child: Text(
                                                                  "OK",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ) // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
                                                              ..show(context)
                                                                  .then(
                                                                      (result) {
                                                                setState(() {
                                                                  // setState() is optional here
                                                                  _wasButtonClicked =
                                                                      result;
                                                                });
                                                              });
                                                          }
                                                        }
                                                        print(
                                                            'Is Favorite $_isFavorite)');
                                                      },
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ), //Title
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star_border,
                                              color: AppColors.thidasaLightBlue,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              itemData.rating ?? "",
                                              style: const TextStyle(
                                                  fontSize: Sizes.dimen_20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Icon(
                                              Icons.circle,
                                              color: AppColors.thidasaLightBlue,
                                              size: 8,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Row(
                                              children: [
                                                for (int i = 0; i < 10; i++)
                                                  DetailsGenresWidget(
                                                      ref
                                                          .read(genresProvider)
                                                          .allGenres[i],
                                                      itemData.genres!),
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Icon(
                                              Icons.circle,
                                              color: AppColors.thidasaLightBlue,
                                              size: 8,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              " " + itemData.releasedYear! ??
                                                  "",
                                              style: const TextStyle(
                                                  fontSize: Sizes.dimen_20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          itemData.description ?? "",
                                          style: const TextStyle(
                                            fontSize: Sizes.dimen_18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ), //Description
                                        SizedBox(
                                          height: 30,
                                        ),

                                        Container(
                                          padding: EdgeInsets.only(right: 10),
                                          child: ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: itemDetailsTvSeries
                                                  .itemDataTvseries?.length,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                List<ItemDataTvSeries?>
                                                    seasonData =
                                                    itemDetailsTvSeries
                                                            .itemDataTvseries![
                                                        index]!;
                                                return Container(
                                                  padding: EdgeInsets.all(7),
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          AppColors.thidasaBlue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),

                                                  /* light theme settings */

                                                  child: ExpansionTile(
                                                    leading: Icon(
                                                      Icons.local_movies,
                                                      color: AppColors
                                                          .thidasaLightBlue,
                                                    ),
                                                    backgroundColor:
                                                        AppColors.thidasaBlue,
                                                    title: Text(
                                                      'Season ' +
                                                          seasonData
                                                              .first!.season!,
                                                      style: TextStyle(
                                                          fontSize:
                                                              Sizes.dimen_26),
                                                    ),
                                                    children: <Widget>[
                                                      for (var i in seasonData)
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  right: 10,
                                                                  bottom: 10),
                                                          child: ListTile(
                                                              leading: Icon(
                                                                Icons
                                                                    .play_circle,
                                                                color: AppColors
                                                                    .thidasaLightBlue
                                                                    .withOpacity(
                                                                        0.8),
                                                              ),
                                                              title: Column(
                                                                children: [
                                                                  Text(
                                                                    'Episode ' +
                                                                        i!.episode! +
                                                                        ':',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          Sizes
                                                                              .dimen_16,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200,
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.8),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 3,
                                                                  ),
                                                                  Text(
                                                                    i!.episodeName!,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          Sizes
                                                                              .dimen_20,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                              ),
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  CupertinoPageRoute(builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return PlayerPage(
                                                                      title: i
                                                                          .episodeName!,
                                                                      url: i
                                                                          .episodeLink!,
                                                                      banner:
                                                                          coverPhoto,
                                                                      rating: itemData
                                                                          .rating!,
                                                                      description:
                                                                          itemData
                                                                              .description!,
                                                                      episode_no:
                                                                          i.episode,
                                                                    );
                                                                  }),
                                                                );
                                                              }),
                                                        )
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ), //Season Builder
                                        SizedBox(
                                          height: 40,
                                        ),

                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            children: [
                                              Text(
                                                "Reviews",
                                                style: const TextStyle(
                                                    fontSize: Sizes.dimen_36,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              UserSharedPreferences
                                                          .getToken() !=
                                                      null
                                                  ? Container(
                                                      child: itemDetailsTvSeries
                                                              .is_already_reviewed!
                                                          ? Container()
                                                          : ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child: Material(
                                                                color: Colors
                                                                    .orange
                                                                    .shade700, // Button color
                                                                child: InkWell(
                                                                  splashColor: Colors
                                                                      .orange
                                                                      .shade800, // Splash color
                                                                  onTap: () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      CupertinoPageRoute(builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return ReviewPage(
                                                                            cid:
                                                                                itemDetailsTvSeries!.cid!);
                                                                      }),
                                                                    );
                                                                  },
                                                                  child: Container(
                                                                      width: 130,
                                                                      padding: EdgeInsets.only(left: 10, right: 10),
                                                                      height: 40,
                                                                      child: Row(
                                                                        children: [
                                                                          Icon(Icons
                                                                              .reviews),
                                                                          SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          Text(
                                                                            "Add Review",
                                                                            style:
                                                                                TextStyle(fontSize: Sizes.dimen_16),
                                                                          ),
                                                                        ],
                                                                      )),
                                                                ),
                                                              ),
                                                            ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ), //Review_Title
                                        SizedBox(
                                          height: 20,
                                        ),
                                        itemDetailsTvSeries.reviews!.isNotEmpty
                                            ? Container(
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        itemDetailsTvSeries
                                                            .reviews?.length,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      Review reviewData =
                                                          itemDetailsTvSeries
                                                              .reviews![index]!;
                                                      return Container(
                                                        padding:
                                                            EdgeInsets.all(7),
                                                        margin: EdgeInsets.only(
                                                            bottom: 10),
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .thidasaBlue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),

                                                        /* light theme settings */

                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .account_circle,
                                                                    color: AppColors
                                                                        .thidasaLightBlue,
                                                                    size: 45,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        reviewData
                                                                            .title!,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                Sizes.dimen_20,
                                                                            color: Colors.white,
                                                                            fontWeight: FontWeight.w400,
                                                                            overflow: TextOverflow.ellipsis),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              180,
                                                                          child:
                                                                              Text(
                                                                            DateFormat('yyyy-MM-dd').format(reviewData.dateTime!) +
                                                                                " by " +
                                                                                reviewData.name!,
                                                                            style: const TextStyle(
                                                                                fontSize: Sizes.dimen_14,
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.w200,
                                                                                overflow: TextOverflow.ellipsis),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                  Expanded(
                                                                      child:
                                                                          Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .star_border,
                                                                        color: AppColors
                                                                            .thidasaLightBlue,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(reviewData
                                                                          .rating!)
                                                                    ],
                                                                  ))
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                reviewData
                                                                    .description!,
                                                                style: const TextStyle(
                                                                    fontSize: Sizes
                                                                        .dimen_18,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              )
                                            : Container(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "No Reviews at the moment",
                                                  style: const TextStyle(
                                                      fontSize: Sizes.dimen_18,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              ), //Season Builder

                                        SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ]),
          );
          ;
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget torrentMovie() {
    return FutureBuilder(
      future: ref.read(itemDetailsProvider).getTorrentMovieDetails(widget.cid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ItemDetailsTorrentMovie itemDetailsTvSeries = snapshot.data!;
          ItemModel itemData = itemDetailsTvSeries.itemData ?? ItemModel();
          String coverPhoto = itemData.bannerPhoto ?? "";
          String photo = itemData.coverPhoto ?? "";

          String title = itemData.title ?? "";

          print(ThidasaApiConstants.imageBannerBaseURL + coverPhoto);
          return Container(
            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  ThidasaApiConstants.imageBannerBaseURL + coverPhoto ?? "",
                  fit: BoxFit.fitHeight,
                  height: 280,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: const SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Icon(Icons.broken_image_outlined),
                      ),
                    );
                  },
                ),
              ),
              ScrollConfiguration(
                behavior: ScrollBehavior(),
                child: GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    color: AppColors.thidasaBlue,
                    child: ListView(
                      children: [
                        Positioned(
                          height: 120,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Stack(
                            children: [
                              Container(
                                height: 450,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    gradient: LinearGradient(
                                        colors: [
                                          AppColors.thidasaDarkBlue
                                              .withOpacity(0.500),
                                          AppColors.thidasaDarkBlue
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.center)),
                              ),
                              Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    height: 350,
                                    padding: EdgeInsets.only(left: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 120,
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            ThidasaApiConstants
                                                    .imageCardBaseURL +
                                                photo,
                                            fit: BoxFit.fitWidth,
                                            width: 160,
                                            errorBuilder: (BuildContext context,
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
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    alignment: Alignment.topLeft,
                                    padding:
                                        EdgeInsets.only(left: 20, right: 10),
                                    color: AppColors.thidasaDarkBlue,
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                title,
                                                style: const TextStyle(
                                                    fontSize: Sizes.dimen_36,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              )),
                                              SizedBox(width: 12),
                                              UserSharedPreferences
                                                          .getToken() !=
                                                      null
                                                  ? FavoriteButton(
                                                      isFavorite:
                                                          itemDetailsTvSeries
                                                              .is_already_wishlisted!,
                                                      iconColor: AppColors
                                                          .thidasaLightBlue,
                                                      iconSize: 50,
                                                      valueChanged:
                                                          (_isFavorite) async {
                                                        var map = new Map<
                                                            String, dynamic>();
                                                        map['cid'] =
                                                            itemData.cid;
                                                        map['uid'] =
                                                            UserSharedPreferences
                                                                .getID();
                                                        if (_isFavorite) {
                                                          bool
                                                              _wasButtonClicked;
                                                          ServerResponse
                                                              serverResponse =
                                                              await ref
                                                                  .read(
                                                                      httpProvider)
                                                                  .addToWishList(
                                                                      map);
                                                          if (serverResponse
                                                                  .code ==
                                                              200) {
                                                            flush = Flushbar<
                                                                bool>(
                                                              title:
                                                                  "Added to Wishlist ",
                                                              message:
                                                                  "The item added to wishlist",
                                                              flushbarPosition:
                                                                  FlushbarPosition
                                                                      .TOP,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          6),
                                                              backgroundColor:
                                                                  Colors.green
                                                                      .shade600,
                                                              icon: Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              mainButton:
                                                                  TextButton(
                                                                onPressed: () {
                                                                  flush.dismiss(
                                                                      true); // result = true
                                                                },
                                                                child: Text(
                                                                  "OK",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ) // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
                                                              ..show(context)
                                                                  .then(
                                                                      (result) {
                                                                setState(() {
                                                                  // setState() is optional here
                                                                  _wasButtonClicked =
                                                                      result;
                                                                });
                                                              });
                                                          }
                                                        } else {
                                                          bool
                                                              _wasButtonClicked;
                                                          ServerResponse
                                                              serverResponse =
                                                              await ref
                                                                  .read(
                                                                      httpProvider)
                                                                  .removeFromWishList(
                                                                      map);
                                                          if (serverResponse
                                                                  .code ==
                                                              200) {
                                                            flush = Flushbar<
                                                                bool>(
                                                              title:
                                                                  "Removed from Wishlist ",
                                                              message:
                                                                  "The item was removed from wishlist",
                                                              flushbarPosition:
                                                                  FlushbarPosition
                                                                      .TOP,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          6),
                                                              backgroundColor:
                                                                  Colors.green
                                                                      .shade600,
                                                              icon: Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              mainButton:
                                                                  TextButton(
                                                                onPressed: () {
                                                                  flush.dismiss(
                                                                      true); // result = true
                                                                },
                                                                child: Text(
                                                                  "OK",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ) // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
                                                              ..show(context)
                                                                  .then(
                                                                      (result) {
                                                                setState(() {
                                                                  // setState() is optional here
                                                                  _wasButtonClicked =
                                                                      result;
                                                                });
                                                              });
                                                          }
                                                        }
                                                        print(
                                                            'Is Favorite $_isFavorite)');
                                                      },
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ), //Title
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star_border,
                                              color: AppColors.thidasaLightBlue,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              itemData.rating ?? "",
                                              style: const TextStyle(
                                                  fontSize: Sizes.dimen_20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Icon(
                                              Icons.circle,
                                              color: AppColors.thidasaLightBlue,
                                              size: 8,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Row(
                                              children: [
                                                for (int i = 0; i < 10; i++)
                                                  DetailsGenresWidget(
                                                      ref
                                                          .read(genresProvider)
                                                          .allGenres[i],
                                                      itemData.genres!),
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Icon(
                                              Icons.circle,
                                              color: AppColors.thidasaLightBlue,
                                              size: 8,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              " " + itemData.releasedYear! ??
                                                  "",
                                              style: const TextStyle(
                                                  fontSize: Sizes.dimen_20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          itemData.description ?? "",
                                          style: const TextStyle(
                                            fontSize: Sizes.dimen_18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ), //Description
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(7),
                                          margin: EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                              color: AppColors.thidasaBlue,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: ExpansionTile(
                                            initiallyExpanded: true,
                                            leading: Icon(
                                              Icons.local_movies,
                                              color: AppColors.thidasaLightBlue,
                                            ),
                                            backgroundColor:
                                                AppColors.thidasaBlue,
                                            title: Text(
                                              'Downloads',
                                              style: TextStyle(
                                                  fontSize: Sizes.dimen_26),
                                            ),
                                            children: <Widget>[
                                              itemDetailsTvSeries.itemDataTorrentmovies![0]!.hd!=""?
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 0),
                                                child: ListTile(
                                                    leading: Icon(
                                                      Icons.download_for_offline_outlined,
                                                      color: AppColors
                                                          .thidasaLightBlue
                                                          .withOpacity(0.8),size: 28,
                                                    ),
                                                    title: Text("HD",style: TextStyle(fontSize: Sizes.dimen_22),),
                                                    onTap: () async {
                                                      Uri _url = Uri.parse(itemDetailsTvSeries.itemDataTorrentmovies![0]!.hd!);

                                                      if(await canLaunchUrl(_url)){
                                                        await launchUrl(_url);
                                                      }
                                                      else{
                                                        throw 'Could not launch $_url';
                                                      }
                                                    }),
                                              ):Container(),
                                              itemDetailsTvSeries.itemDataTorrentmovies![0]!.fullhd!=""?
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 0),
                                                child: ListTile(
                                                    leading: Icon(
                                                      Icons.download_for_offline_outlined,
                                                      color: AppColors
                                                          .thidasaLightBlue
                                                          .withOpacity(0.8),size: 28,
                                                    ),
                                                    title: Text("Full HD",style: TextStyle(fontSize: Sizes.dimen_22),),
                                                    onTap: () async {
                                                      Uri _url = Uri.parse(itemDetailsTvSeries.itemDataTorrentmovies![0]!.hd!);

                                                      if(await canLaunchUrl(_url)){
                                                        await launchUrl(_url);
                                                      }
                                                      else{
                                                        throw 'Could not launch $_url';
                                                      }
                                                    }),
                                              ):Container(),
                                              itemDetailsTvSeries.itemDataTorrentmovies![0]!.uhd!=""?
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 10),
                                                child: ListTile(
                                                    leading: Icon(
                                                      Icons.download_for_offline_outlined,
                                                      color: AppColors
                                                          .thidasaLightBlue
                                                          .withOpacity(0.8),size: 28,
                                                    ),
                                                    title: Text("Ultra HD",style: TextStyle(fontSize: Sizes.dimen_22),),
                                                    onTap: () async {
                                                      Uri _url = Uri.parse(itemDetailsTvSeries.itemDataTorrentmovies![0]!.hd!);

                                                      if(await canLaunchUrl(_url)){
                                                        await launchUrl(_url);
                                                      }
                                                      else{
                                                        throw 'Could not launch $_url';
                                                      }
                                                    }),
                                              ):Container(),
                                            ],
                                          ),
                                        ),

                                        SizedBox(
                                          height: 40,
                                        ),

                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            children: [
                                              Text(
                                                "Reviews",
                                                style: const TextStyle(
                                                    fontSize: Sizes.dimen_36,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              UserSharedPreferences
                                                          .getToken() !=
                                                      null
                                                  ? Container(
                                                      child: itemDetailsTvSeries
                                                              .is_already_reviewed!
                                                          ? Container()
                                                          : ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child: Material(
                                                                color: Colors
                                                                    .orange
                                                                    .shade700, // Button color
                                                                child: InkWell(
                                                                  splashColor: Colors
                                                                      .orange
                                                                      .shade800, // Splash color
                                                                  onTap: () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      CupertinoPageRoute(builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return ReviewPage(
                                                                            cid:
                                                                                itemDetailsTvSeries!.cid!);
                                                                      }),
                                                                    );
                                                                  },
                                                                  child: Container(
                                                                      width: 130,
                                                                      padding: EdgeInsets.only(left: 10, right: 10),
                                                                      height: 40,
                                                                      child: Row(
                                                                        children: [
                                                                          Icon(Icons
                                                                              .reviews),
                                                                          SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          Text(
                                                                            "Add Review",
                                                                            style:
                                                                                TextStyle(fontSize: Sizes.dimen_16),
                                                                          ),
                                                                        ],
                                                                      )),
                                                                ),
                                                              ),
                                                            ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ), //Review_Title
                                        SizedBox(
                                          height: 20,
                                        ),
                                        itemDetailsTvSeries.reviews!.isNotEmpty
                                            ? Container(
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        itemDetailsTvSeries
                                                            .reviews?.length,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      Review reviewData =
                                                          itemDetailsTvSeries
                                                              .reviews![index]!;
                                                      return Container(
                                                        padding:
                                                            EdgeInsets.all(7),
                                                        margin: EdgeInsets.only(
                                                            bottom: 10),
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .thidasaBlue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),

                                                        /* light theme settings */

                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .account_circle,
                                                                    color: AppColors
                                                                        .thidasaLightBlue,
                                                                    size: 45,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        reviewData
                                                                            .title!,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                Sizes.dimen_20,
                                                                            color: Colors.white,
                                                                            fontWeight: FontWeight.w400,
                                                                            overflow: TextOverflow.ellipsis),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              180,
                                                                          child:
                                                                              Text(
                                                                            DateFormat('yyyy-MM-dd').format(reviewData.dateTime!) +
                                                                                " by " +
                                                                                reviewData.name!,
                                                                            style: const TextStyle(
                                                                                fontSize: Sizes.dimen_14,
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.w200,
                                                                                overflow: TextOverflow.ellipsis),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                  Expanded(
                                                                      child:
                                                                          Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .star_border,
                                                                        color: AppColors
                                                                            .thidasaLightBlue,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(reviewData
                                                                          .rating!)
                                                                    ],
                                                                  ))
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                reviewData
                                                                    .description!,
                                                                style: const TextStyle(
                                                                    fontSize: Sizes
                                                                        .dimen_18,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              )
                                            : Container(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "No Reviews at the moment",
                                                  style: const TextStyle(
                                                      fontSize: Sizes.dimen_18,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              ), //Season Builder

                                        SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ]),
          );
          ;
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
