import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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
import 'package:flushbar/flushbar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:news/widgets/saved_item_card.dart';

import '../models/articles_model.dart';
import '../models/server_response_model.dart';
import '../providers/navigation_provider.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'navigation.dart';







class EditProfilePage extends ConsumerStatefulWidget {
  EditProfilePage({Key? key}) : super(key: key);
  String email = UserSharedPreferences.getEmail()??"";
  String name = UserSharedPreferences.getName()??"";
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  TextEditingController searchController = TextEditingController();

  late Flushbar flush;

  late List<SavedItem> savedItems;
  bool isLoading = false;
  bool _hidepassword = true;
  Widget buildButton() {
    final isFormValid = widget.email.isNotEmpty && widget.name.isNotEmpty ;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: isFormValid ? null : Colors.grey.shade700,
      ),
      onPressed: () async {
        print("User Id");
        var map = new Map<String, dynamic>();
        map['uid'] = UserSharedPreferences.getID();
        map['name'] = widget.name??"";
        map['email'] = widget.email??"";
        ServerResponse serverResponse = await ref.read(httpProvider).editProfile(map);

        if(serverResponse.code==200){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              NavigationController()), (Route<dynamic> route) => false);
          bool _wasButtonClicked;
          UserSharedPreferences.setName(map['name']);
          UserSharedPreferences.setEmail(map['email']);
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
          bool _wasButtonClicked;

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
          bool _wasButtonClicked;

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
      },
      child: Text('SAVE'),
    );

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
   // SavedItemsDatabase.instance.close();

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50,),

              Text("Edit Profile",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Sizes.dimen_26,
                color: AppColors.white,
              ),
              ),
              SizedBox(height: 10,),

              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Icon(Icons.account_circle,color: AppColors.thidasaLightBlue,size: 140,),
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
                        prefixIcon: Icon(Icons.person),
                        labelText: "Name",
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                        )
                    ),
                    initialValue:UserSharedPreferences.getName(),
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
                    initialValue:UserSharedPreferences.getEmail(),
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

                  // TextFormField(
                  //   obscureText: _hidepassword,
                  //   decoration: InputDecoration(
                  //       prefixIconColor: AppColors.white,
                  //       prefixIcon: Icon(Icons.fingerprint),
                  //       labelText: "Password",
                  //       border: OutlineInputBorder(),
                  //       suffixIcon: IconButton(
                  //         onPressed: (){
                  //           setState(() {
                  //             _hidepassword = !_hidepassword;
                  //             print("hi" + _hidepassword.toString());
                  //           });
                  //         },
                  //         icon: _hidepassword?Icon(Icons.visibility_off):Icon(Icons.visibility),
                  //       )
                  //   ),
                  //   validator: (title) => title != null && title.isEmpty
                  //       ? 'The Password cannot be empty'
                  //       : null,
                  //   onChanged: (text){
                  //     setState(() {
                  //       widget.password = text;
                  //     });
                  //   },
                  // ),
                  SizedBox(height: 20,),
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
