import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:news/providers/http_provider.dart';
import 'package:news/utils/shared_preferences.dart';
import 'package:news/views/account_page.dart';
import 'package:news/views/home_page.dart';
import 'package:news/views/save_page.dart';
import 'package:news/views/search_page.dart';
import 'package:news/views/sign_in_page.dart';
import 'package:news/views/watch_later_page.dart';

import '../constants/color_constants.dart';
import '../widgets/custom_appBar.dart';


class NavigationController extends ConsumerStatefulWidget {
  int? gotPageID;
  NavigationController({Key? key,  this.gotPageID}) : super(key: key);

  @override
  _NavigationControllerState createState() =>
      _NavigationControllerState();
}

class _NavigationControllerState
    extends ConsumerState<NavigationController> {
  final List<Widget> pages = [
    HomePage(
      key: PageStorageKey('HomePage'),
    ),
    SearchPage(
      key: PageStorageKey('SearchPage'),
    ),
    WatchLaterPage(
      key: PageStorageKey('WatchLaterPage'),
    ),
    AccountPage(
      key: PageStorageKey('AccountPage'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() => _selectedIndex = widget.gotPageID??0);

  }


  Widget _bottomNavigationBar(int selectedIndex) => Container(
    child: CurvedNavigationBar(
      backgroundColor: AppColors.thidasaDarkBlue,
      height: 50,
      color: AppColors.thidasaBlue,
      animationDuration: Duration(milliseconds: 300),
      items: [
        Icon(
          Icons.home,
          color: AppColors.thidasaLightBlue,
        ),
        Icon(
          Icons.search,
          color: AppColors.thidasaLightBlue,
        ),
        Icon(
          Icons.favorite,
          color: AppColors.thidasaLightBlue,
        ),
        Icon(
          Icons.account_circle_rounded,
          color: AppColors.thidasaLightBlue,
        )
      ],
      index: _selectedIndex,
      onTap: (int index){

          setState(() => _selectedIndex = index);

      },
      letIndexChange: (int index){
        if(index==2 || index==3){
          if(UserSharedPreferences.getToken()=="" || UserSharedPreferences.getToken()==null){
            //setState(() => _selectedIndex = 0);
            Navigator.push(context,
              CupertinoPageRoute(
                  builder: (BuildContext context){
                    return  SignInPage();
                  }
              ),
            );
            return false;
          }
          else{
            return true;
          }
        }{
          return true;
        }

      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.thidasaDarkBlue,
      appBar: customAppBar('Thidasa', context, actions: [
       ref.read(httpProvider).token == "" ?GestureDetector(
         onTap: (){
           Navigator.push(context,
           CupertinoPageRoute(
             builder: (BuildContext context){
               return  SignInPage();
             }
           ),
           );
         },
         child:
         Row(
           children: [
             Text("Sign in",style: TextStyle(
               fontSize: 16,
             ),),
             SizedBox(width: 7,),
             Icon(
               Icons.login,
             ),
             SizedBox(width: 15,),

           ],
         ),
       ):GestureDetector(
         onTap: (){
           setState(() => _selectedIndex = 3);
         },
         child:
         Row(
           children: [
             Icon(
               Icons.account_circle_rounded,
             ),
             SizedBox(width: 7,),
         SizedBox(
         child:SizedBox(child: Text(UserSharedPreferences.getName()??"",
           overflow: TextOverflow.ellipsis,
           style: TextStyle(
             fontSize: 16,
           ),),
         )
             ),
             SizedBox(width: 15,),



           ],
         ),
       )
      ]),
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}