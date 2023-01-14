import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/constants/size_constants.dart';
import 'package:news/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:news/db/saved_item_database.dart';
import 'package:news/models/saved_item_model.dart';
import 'package:news/views/save_page.dart';
import 'package:news/widgets/trending_list_genres.dart';

import '../constants/color_constants.dart';
import '../constants/newsApi_constants.dart';
import '../models/genres_model.dart';
import '../providers/genres_provider.dart';

class GenreCard extends StatelessWidget {
  final String id;
  final String imgUrl, title;



  GenreCard(this.id, this.title, this.imgUrl, ){

  }

  @override
  Widget build(BuildContext context) {





    return Stack(
      children: [
        Container(
          height: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(10),
                      child: Image.network(
                        imgUrl ?? " ",
                        fit: BoxFit.fitHeight,
                        height: 180,
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
                        height: 120,
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
                                        .withOpacity(0.000),
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
                                      horizontal: 5, vertical: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title!,
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


                                    ],
                                  ))),
                        )),

                  ]),



            ],
          ),
        )
      ],
    );




  }


}
