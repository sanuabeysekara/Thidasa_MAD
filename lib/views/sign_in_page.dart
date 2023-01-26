import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:news/constants/color_constants.dart';
import 'package:news/constants/size_constants.dart';
import 'package:news/constants/ui_constants.dart';
import 'package:news/controllers/news_controller.dart';
import 'package:news/models/saved_item_model.dart';
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







class SignInPage extends ConsumerStatefulWidget {
  SignInPage({Key? key}) : super(key: key);
  String email = "";
  String password ="";
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  bool _isLoadingPage = false;
  TextEditingController searchController = TextEditingController();

  late Flushbar flush;

  late List<SavedItem> savedItems;
  bool isLoading = false;
  bool _hidepassword = true;
  Widget buildButton() {
    final isFormValid = widget.email.isNotEmpty && widget.password.isNotEmpty ;

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
          map['email'] = widget.email;
          map['password'] = widget.password;

          if(await ref.read(httpProvider).signIn(map)){


            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                NavigationController()), (Route<dynamic> route) => false);

            bool? _wasButtonClicked;
            ref.read(httpProvider).updateSharedPreferenses();
            flush = Flushbar<bool>(
              title: "Hey "+UserSharedPreferences.getName()!,
              message: "The Entertainment of your choice is beneath your finger tips.",
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
            ref.read(httpProvider).updateSharedPreferenses();
            bool? _wasButtonClicked;
            setState(() {
              _isLoadingPage = false;
            });
            flush = Flushbar<bool>(
              animationDuration: Duration(milliseconds: 400),
              title: "Oh! Snap",
              message: "The Email or Password is Invalid.",
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
          print( widget.email+ widget.password);
        }

      },
      child: _isLoadingPage? CircularProgressIndicator(color: Colors.white,):Text("Sign In"),
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
              SizedBox(height: 50,),
              Container(
                child:Image.asset('assets/images/logo.png', fit: BoxFit.fitHeight, height: 80,),),
              SizedBox(height: 30,),
              Text("Welcome Back,",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Sizes.dimen_32,
                color: AppColors.white,
              ),
              ),
              SizedBox(height: 10,),

              Text("Sign in and explore a whole new world of entertainment.",
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
                    decoration: InputDecoration(
                      prefixIconColor: AppColors.white,
                      prefixIcon: Icon(Icons.mail),
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                      )
                    ),
                    validator: (title) => title != null && title.isEmpty
                        ? 'The Email cannot be empty'
                        : null,
                    onChanged: (text){
                      setState(() {
                        widget.email = text;
                      });
                    },
                  ),
                  SizedBox(height: 20,),

                  TextFormField(
                    obscureText: _hidepassword,
                    decoration: InputDecoration(
                        prefixIconColor: AppColors.white,
                        prefixIcon: Icon(Icons.fingerprint),
                        labelText: "Password",
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              _hidepassword = !_hidepassword;
                              print("hi" + _hidepassword.toString());
                            });
                          },
                          icon: _hidepassword?Icon(Icons.visibility_off):Icon(Icons.visibility),
                        )
                    ),
                    validator: (title) => title != null && title.isEmpty
                        ? 'The Password cannot be empty'
                        : null,
                    onChanged: (text){
                      setState(() {
                        widget.password = text;
                      });
                    },
                  ),
                  SizedBox(height: 30,),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: buildButton(),
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(context,
                          CupertinoPageRoute(
                              builder: (BuildContext context){
                                return SignUpPage();
                              }
                          ),
                        );

                      },
                      child: Text("SIGN UP"),
                      style: ElevatedButton.styleFrom(primary: AppColors.thidasaBlue),

                  ),
                  )

                ],
              ))


            ],
          ),
        ),
      ),
    );


  }



}
