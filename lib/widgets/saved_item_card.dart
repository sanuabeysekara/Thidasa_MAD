import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/constants/size_constants.dart';
import 'package:news/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:news/models/saved_item_model.dart';
import 'package:news/views/save_page.dart';
import 'package:news/widgets/trending_list_genres.dart';

import '../constants/color_constants.dart';
import '../constants/newsApi_constants.dart';
import '../models/genres_model.dart';
import '../providers/genres_provider.dart';
import '../utils/image_utility.dart';

class SavedItemCard extends StatelessWidget {
  final String id;
  final String imgUrl, title, genres, rating, offlineStatus;
  String type;



  SavedItemCard(this.id, this.imgUrl, this.title, this.type, this.rating, this.genres, this.offlineStatus){
    switch (type) {
      case "tvseries":
        this.type = "TV Series";
        break;
      case "torrent_movies":
        this.type = "Torrent Movie";
        break;
      case "online_movie":
        this.type = "Online Movie";
        break;
      case "interviews":
        this.type = "Interview";
        break;
      case "offline_movies":
        this.type = "Offline Movie";
        break;
      case "live_stream":
        this.type = "Live Stream";
        break;

    }
  }

  @override
  Widget build(BuildContext context) {





    return

      offlineStatus == "not_downloaded"?
      Stack(
        children: [
          Container(
            height: 320,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                    children: [
                      ClipRRect(

                        borderRadius:
                        BorderRadius.circular(10),
                        child: Image.memory(
                          Utility.dataFromBase64String(imgUrl),
                          fit: BoxFit.fill,
                          width: 155,
                          height: 230,
                          alignment: Alignment.center,
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
                                height: 232,
                                width: double.infinity,
                                child: Icon(Icons
                                    .broken_image_outlined),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius:  BorderRadius.circular(10),
                            color: AppColors.thidasaBlue.withOpacity(0.85),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Icon(Icons.star_border,color: AppColors.thidasaLightBlue,size: 14,),
                              SizedBox(width: 8,),
                              Text(
                                rating,
                                style: const TextStyle(
                                  fontSize: Sizes
                                      .dimen_14,
                                  color:
                                  Colors.white,
                                  fontWeight:
                                  FontWeight.normal,

                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(0),
                        child: Container(
                          width: double.infinity,
                          height:230,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(10),
                              color: Colors.black.withOpacity(0.7),

                            ),
                            alignment: Alignment.center,
                            height: 70,
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(onPressed: (){}, icon: Icon(Icons.download_for_offline,size: 32,)),
                                SizedBox(
                                  height: 6.0,
                                ),
                                Text(
                                  "Download File",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ]),
                SizedBox(height: 10,),
                Flexible(
                  child:Container(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: Sizes
                            .dimen_20,
                        color:
                        Colors.white,
                        fontWeight:
                        FontWeight.normal,

                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius:  BorderRadius.circular(15),
                      color: AppColors.thidasaBlue
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    type,
                    style: const TextStyle(
                      fontSize: Sizes
                          .dimen_16,
                      color:
                      Colors.white,
                      fontWeight:
                      FontWeight.normal,

                    ),
                  ),
                )


              ],
            ),
          )
        ],
      ):

    Stack(
      children: [
        Container(
          height: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(10),
                      child: Image.memory(
                        Utility.dataFromBase64String(imgUrl),
                        fit: BoxFit.fill,

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
                    Container(
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius:  BorderRadius.circular(10),
                          color: AppColors.thidasaBlue.withOpacity(0.85),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Icon(Icons.star_border,color: AppColors.thidasaLightBlue,size: 14,),
                            SizedBox(width: 8,),
                            Text(
                              rating,
                              style: const TextStyle(
                                fontSize: Sizes
                                    .dimen_14,
                                color:
                                Colors.white,
                                fontWeight:
                                FontWeight.normal,

                              ),
                            )
                          ],
                        ),
                      ),
                    )

                  ]),
              SizedBox(height: 10,),
              Flexible(
                child:Container(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: Sizes
                          .dimen_20,
                      color:
                      Colors.white,
                      fontWeight:
                      FontWeight.normal,

                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                  borderRadius:  BorderRadius.circular(15),
                  color: AppColors.thidasaBlue
                ),
                padding: EdgeInsets.all(10),
                child: Text(
                  type,
                  style: const TextStyle(
                    fontSize: Sizes
                        .dimen_16,
                    color:
                    Colors.white,
                    fontWeight:
                    FontWeight.normal,

                  ),
                ),
              )


            ],
          ),
        )
      ],
    );




  }


}
