import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:news/constants/color_constants.dart';
import 'package:news/constants/size_constants.dart';
import 'package:news/constants/ui_constants.dart';
import 'package:news/controllers/news_controller.dart';
import 'package:news/models/saved_item_model.dart';
import 'package:news/models/server_response_model.dart';
import 'package:news/providers/http_provider.dart';
import 'package:news/providers/news_provider.dart';
import 'package:news/utils/shared_preferences.dart';
import 'package:news/views/filter_page.dart';
import 'package:news/views/home_page.dart';
import 'package:news/views/settings_page.dart';
import 'package:news/views/sign_up_page.dart';
import 'package:news/views/web_view_news.dart';
import 'package:news/views/your_page.dart';
import 'package:news/widgets/custom_appBar.dart';
import 'package:news/widgets/news_card.dart';
//import 'package:news/widgets/side_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:news/widgets/saved_item_card.dart';

import '../models/articles_model.dart';
import '../providers/navigation_provider.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'navigation.dart';







class ReviewPage extends ConsumerStatefulWidget {
  String cid;
  ReviewPage({Key? key, required this.cid}) : super(key: key);
  String title = "";
  String review ="";
  int rating=100;
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends ConsumerState<ReviewPage> {
  TextEditingController searchController = TextEditingController();

  late Flushbar flush;
  bool _isLoadingPage = false;

  late List<SavedItem> savedItems;
  bool isLoading = false;
  bool _hidepassword = true;
  Widget buildButton() {
    final isFormValid = widget.title.isNotEmpty && widget.review.isNotEmpty && widget.rating != 100  ;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: isFormValid ? null : Colors.grey.shade700,
      ),
      onPressed: () async {
      if(isFormValid){
        setState(() {
          _isLoadingPage = true;
        });
        var map = new Map<String, dynamic>();
        map['cid'] = widget.cid;
        map['uid'] = UserSharedPreferences.getID();
        map['title'] = widget.title;
        map['review'] = widget.review;
        map['rating'] = widget.rating.toString();
        ServerResponse responseGot = await ref.read(httpProvider).addReview(map);
        if(responseGot.code==200){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              NavigationController()), (Route<dynamic> route) => false);

          bool? _wasButtonClicked;
          flush = Flushbar<bool>(
            title: "Review Added",
            message: responseGot.message,
            flushbarPosition: FlushbarPosition.TOP,
            duration: Duration(seconds: 6),
            backgroundColor: Colors.green.shade600,
            icon: Icon(
              Icons.check_circle_outline,
              color: Colors.white,),
            mainButton: TextButton(
              onPressed: () {
                flush.dismiss(true); // result = true
              },
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
            ),) // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
            ..show(context).then((result) {
              setState(() { // setState() is optional here
                _wasButtonClicked = result;
              });
            });
        }
        else{
          bool? _wasButtonClicked;
          setState(() {
            _isLoadingPage = false;
          });
          flush = Flushbar<bool>(
            animationDuration: Duration(milliseconds: 400),
            title: "Oh! Snap",
            message: responseGot.message,
            flushbarPosition: FlushbarPosition.TOP,
            duration: Duration(seconds: 7),
            backgroundColor: Colors.red.shade600,
            icon: Icon(
              Icons.dangerous_rounded,
              color: Colors.white,),
            mainButton: TextButton(
              onPressed: () {
                flush.dismiss(true); // result = true
              },
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
            ),) // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
            ..show(context).then((result) {
              setState(() { // setState() is optional here
                _wasButtonClicked = result;
              });
            });
        }
        print( widget.title+ widget.review+widget.rating.toString());
      }

      },
      child: _isLoadingPage? CircularProgressIndicator(color: Colors.white,):Text("Add"),
    );

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
   // SavedItemsDatabase.instance.close();
    setState(() {
      _isLoadingPage = false;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.thidasaDarkBlue,

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Container(
                child:Image.asset('assets/images/review.png', fit: BoxFit.fitHeight, height: 220,),),
              Text("Add Review",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Sizes.dimen_32,
                color: AppColors.white,
              ),
              ),
              SizedBox(height: 10,),

              Text("Add your Review and help others know about the show",
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: Sizes.dimen_16,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 30,),
              Form(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    inputFormatters: [
                    new LengthLimitingTextInputFormatter(20),
                    ],
                    decoration: InputDecoration(
                      prefixIconColor: AppColors.white,
                      prefixIcon: Icon(Icons.title),
                      labelText: "Title",
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                      )
                    ),
                    validator: (title) => title != null && title.isEmpty
                        ? 'The Title cannot be empty'
                        : null,
                    onChanged: (text){
                      setState(() {
                        widget.title = text;
                      });
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    inputFormatters: [
                      new LengthLimitingTextInputFormatter(100),
                    ],
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        prefixIconColor: AppColors.white,
                        prefixIcon: Icon(Icons.reviews),
                        labelText: "Review",
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                        )
                    ),
                    validator: (title) => title != null && title.isEmpty
                        ? 'The Review cannot be empty'
                        : null,
                    onChanged: (text){
                      setState(() {
                        widget.review = text;
                      });
                    },
                  ),
                  SizedBox(height: 20,),
                  RatingBar(
                      initialRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      glowColor: Colors.orange,
                      ratingWidget: RatingWidget(
                          full: const Icon(Icons.star, color: Colors.orange),
                          half: const Icon(
                            Icons.star_half,
                            color: Colors.orange,
                          ),
                          empty: const Icon(
                            Icons.star_outline,
                            color: Colors.orange,
                          )),
                      onRatingUpdate: (value) {
                        setState(() {
                          if(value==0.0){
                            widget.rating = 0;

                          }
                          else if(value == 0.5){
                            widget.rating = 1;
                          }
                          else if(value == 1.0){
                            widget.rating = 2;
                          }
                          else if(value == 1.5){
                            widget.rating = 3;
                          }
                          else if(value == 2.0){
                            widget.rating = 4;
                          }
                          else if(value == 2.5){
                            widget.rating = 5;
                          }
                          else if(value == 3.0){
                            widget.rating = 6;
                          }
                          else if(value == 3.5){
                            widget.rating = 7;
                          }
                          else if(value == 4.0){
                            widget.rating = 8;
                          }
                          else if(value == 4.5){
                            widget.rating = 9;
                          }
                          else if(value == 5.0){
                            widget.rating = 10;
                          }
                          else{
                            widget.rating = 10;
                          }
                          print("Rating is"+widget.rating.toString());
                        });
                      }),
                  SizedBox(height: 30,),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: buildButton(),
                  ),
                  SizedBox(height: 20,),

                ],
              ))


            ],
          ),
        ),
      ),
    );


  }



}
