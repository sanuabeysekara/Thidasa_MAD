import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/size_constants.dart';
import '../models/genres_model.dart';
import '../providers/genres_provider.dart';

class TrendingGenresWidget extends StatefulWidget {
  final GenreModel genres;
  final String dynamicGenres;

  const TrendingGenresWidget(this.genres, this.dynamicGenres,{Key? key}) : super(key: key);

  @override
  State<TrendingGenresWidget> createState() => _TrendingGenresWidgetState();
}

class _TrendingGenresWidgetState extends State<TrendingGenresWidget> {
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    final splittedDynamicGenres = widget.dynamicGenres.split(',');
    print(splittedDynamicGenres); // [Hello, world!];
    if(splittedDynamicGenres.contains(widget.genres.genreId)){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.blueGrey.shade700,
      ),
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.only(right: 7),

      child: Text(widget.genres.genreName!,
          style: const TextStyle(
              fontSize: Sizes
                  .dimen_12,
              color:
              Colors.white,
              fontWeight:
              FontWeight
                  .bold)
      ),


    );}
    else{
      return Container();
    }
  }
}
