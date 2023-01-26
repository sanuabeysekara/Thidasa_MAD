import 'package:carousel_slider/carousel_slider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:news/constants/color_constants.dart';
import 'package:news/constants/size_constants.dart';
import 'package:news/constants/ui_constants.dart';
import 'package:news/controllers/news_controller.dart';
import 'package:news/models/saved_item_model.dart';
import 'package:news/models/server_response_model.dart';
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
import '../providers/http_provider.dart';
import '../providers/navigation_provider.dart';
import '../widgets/bottom_navigation_bar.dart';







class SignUpPage extends ConsumerStatefulWidget {
  SignUpPage({Key? key}) : super(key: key);
  String name="";
  String email = "";
  String password ="";
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  TextEditingController searchController = TextEditingController();
  late Flushbar flush;
  bool _isLoadingPage = false;

  late List<SavedItem> savedItems;
  bool isLoading = false;
  bool _hidepassword = true;
  Widget buildButton() {
    final isFormValid = widget.email.isNotEmpty && widget.password.isNotEmpty && widget.name.isNotEmpty ;

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
          map['name'] = widget.name;
          map['email'] = widget.email;
          map['password'] = widget.password;
          ServerResponse serverResponse = await ref.read(httpProvider).signUp(map);

          if(serverResponse.code==200){
            Navigator.pop(context, true); // dialog returns true

            bool? _wasButtonClicked;

            flush = Flushbar<bool>(
              title: "Success!",
              message: serverResponse.message,
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
          else if(serverResponse.code==500){
            bool? _wasButtonClicked;
            setState(() {
              _isLoadingPage = false;
            });
            flush = Flushbar<bool>(
              animationDuration: Duration(milliseconds: 400),
              title: "Oh! Snap",
              message: serverResponse.message,
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

          else{
            bool? _wasButtonClicked;
            setState(() {
              _isLoadingPage = false;
            });
            flush = Flushbar<bool>(
              animationDuration: Duration(milliseconds: 400),
              title: "Oh! Snap",
              message: serverResponse.message,
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
      child: _isLoadingPage? CircularProgressIndicator(color: Colors.white,):Text("Sign Up"),
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
              Text("Sign Up",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Sizes.dimen_32,
                color: AppColors.white,
              ),
              ),
              SizedBox(height: 10,),

              Text("Sign up and explore a whole new world of entertainment.",
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
                        prefixIcon: Icon(Icons.person_outline_outlined),
                        labelText: "Name",
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                        )
                    ),
                    validator: (title) => title != null && title.isEmpty
                        ? 'The Name cannot be empty'
                        : null,
                    onChanged: (text){
                      setState(() {
                        widget.name = text;
                      });
                    },
                  ),
                  SizedBox(height: 20,),

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

                ],
              ))


            ],
          ),
        ),
      ),
    );


  }



}
