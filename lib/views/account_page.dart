import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:news/constants/color_constants.dart';
import 'package:news/constants/size_constants.dart';
import 'package:news/constants/ui_constants.dart';
import 'package:news/controllers/news_controller.dart';
import 'package:news/db/saved_item_database.dart';
import 'package:news/models/saved_item_model.dart';
import 'package:news/providers/news_provider.dart';
import 'package:news/utils/shared_preferences.dart';
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
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/articles_model.dart';
import '../providers/navigation_provider.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'edit_profile_page.dart';







class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState {
  TextEditingController searchController = TextEditingController();


  late List<SavedItem> savedItems;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
   // SavedItemsDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.savedItems = await SavedItemsDatabase.instance.readAllItems();

    setState(() => isLoading = false);
  }


  @override
  Widget build(BuildContext context) {


    return Center(
      child: Column(
        children: [
          SizedBox(height: 30,),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10)
            ),
            child: Icon(Icons.account_circle,color: AppColors.thidasaLightBlue,size: 140,),
          ),
          SizedBox(height: 8,),
          SizedBox(
            child: Text(
              UserSharedPreferences.getName()??"",
              style: TextStyle(
                fontSize: Sizes.dimen_18,
              ),
            ),
          ),
          SizedBox(height: 4,),
          SizedBox(
            child: Text(
              UserSharedPreferences.getEmail()??"",
              style: TextStyle(
                fontSize: Sizes.dimen_14,
                fontWeight: FontWeight.w200
              ),
            ),
          ),
          SizedBox(height: 30,),

          GestureDetector(
            onTap: (){
              Navigator.push(context,
                CupertinoPageRoute(
                    builder: (BuildContext context){
                      return  EditProfilePage();
                    }
                ),
              );

            },
             child: Container(
                width: 300,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: AppColors.thidasaBlue,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 25,),
                    Text("Edit Profile",style: TextStyle(fontSize: Sizes.dimen_16),),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Expanded(
                      child: Icon(Icons.arrow_forward_ios_rounded),
                    )
                  ],
                ),
              )
          ),
          SizedBox(height: 10,),

          GestureDetector(
              onTap: () async {
                final pref = await SharedPreferences.getInstance();
                await pref.clear();
                Restart.restartApp();


              },
              child: Container(
                width: 300,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: AppColors.thidasaBlue,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 25,),
                    Text("Logout",style: TextStyle(fontSize: Sizes.dimen_16),),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Expanded(
                      child: Icon(Icons.arrow_forward_ios_rounded),
                    )
                  ],
                ),
              )
          )
        ],
      )
    );
  }



}
