import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/size_constants.dart';
import '../models/genres_model.dart';
import '../providers/genres_provider.dart';

class DetailsGenresWidget extends StatefulWidget {
  final GenreModel genres;
  final String dynamicGenres;

  const DetailsGenresWidget(this.genres, this.dynamicGenres,{Key? key}) : super(key: key);

  @override
  State<DetailsGenresWidget> createState() => _DetailsGenresWidgetState();
}

class _DetailsGenresWidgetState extends State<DetailsGenresWidget> {
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    final splittedDynamicGenres = widget.dynamicGenres.split(',');
    print(splittedDynamicGenres); // [Hello, world!];
    if(splittedDynamicGenres.contains(widget.genres.genreId)){
    return Text(" "+widget.genres.genreName!+" | ",
        style: const TextStyle(
            fontSize: Sizes
                .dimen_20,
            color:
            Colors.white,
            fontWeight:
            FontWeight
                .normal)
    );}
    else{
      return Container();
    }
  }
}
