import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:news/constants/color_constants.dart';
import 'package:news/constants/size_constants.dart';
import 'package:news/constants/ui_constants.dart';
import 'package:news/controllers/news_controller.dart';
import 'package:news/db/saved_item_database.dart';
import 'package:news/models/saved_item_model.dart';
import 'package:news/providers/news_provider.dart';
import 'package:news/utils/extensions.dart';
import 'package:news/views/filter_page.dart';
import 'package:news/views/home_page.dart';
import 'package:news/views/save_page.dart';
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

import '../models/articles_model.dart';
import '../providers/navigation_provider.dart';
import '../utils/shared_preferences.dart';
import '../utils/shared_preferences.dart';
import '../utils/utils.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState {
  TextEditingController searchController = TextEditingController();

  int _selectedIndex = 2;

  late List<SavedItem> savedItems;
  bool isLoading = false;
  String? myCountry =  UserSharedPreferences.getDefaultCountry();
  String? myCategory =  UserSharedPreferences.getDefaultCategory();
 // String colorString =  UserSharedPreferences.getThemeColor() == null ? "232324": UserSharedPreferences.getThemeColor()!;
  Color mycolor =  UserSharedPreferences.getThemeColor() == null ?Color(0xff07145e) : ColorExtension.toColor(UserSharedPreferences.getThemeColor()!);
  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    // SavedItemsDatabase.instance.close();

    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (r) => false);
    }
    if (index == 1) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SavePage()),
          (r) => false);
    }
    if (index == 2) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
          (r) => false);
    }
  }



  @override
  Widget build(BuildContext context) {


    print(myCountry);
    print(myCategory);
    return Scaffold(
      //drawer: sideDrawer(newsController),
      appBar: customAppBar(
        'Settings',
        context,
      ),
      body: Center(
        child: settingsForm(),
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.burgundy,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.chat),
          //   label: 'Chats',
          // ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget settingsForm() => ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                //Icon(Icons.),
                Expanded(
                    child: Text(
                  "Default Country",
                  style: TextStyle(fontSize: 18),
                )),
                Expanded(
                  child: DropdownButtonFormField<String>(

                      //validator: (value) => value == null ? "Select a country" : null,

                      value: myCountry == null
                          ? "us"
                          : myCountry,
                      onChanged: (String? newValue) {
                        setState(() {
                          myCountry = newValue!;
                        });
                        //ref.read(newsProvider).cName = listOfCountry[i]['name']!.toUpperCase();

                      },
                      items: dropdownItems),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                //Icon(Icons.),
                Expanded(
                    child: Text(
                  "Default Category",
                  style: TextStyle(fontSize: 18),
                )),
                Expanded(
                  child: DropdownButtonFormField<String>(

                      //validator: (value) => value == null ? "Select a country" : null,

                      value: myCategory == null
                          ? "technology"
                          :myCategory,
                      onChanged: (String? newValue) {
                        setState(() {
                          myCategory = newValue!;
                        });

                      },
                      items: dropdownCategory),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                //Icon(Icons.),
                Expanded(
                    child: Text(
                  "Theme Color",
                  style: TextStyle(fontSize: 18),
                )),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: mycolor,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Pick a color!'),
                              content: SingleChildScrollView(
                                child: MaterialPicker(
                                  pickerColor: mycolor, //default color
                                  onColorChanged: (Color color) {
                                    //on color picked
                                    print(color.value.toRadixString(16));
                                    setState(() {
                                      mycolor = color;
                                    });
                                  },
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('DONE'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); //dismiss the color picker
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: Text("Pick the Theme Color"),
                  ),
                )
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(80.0),
            child: ElevatedButton(
              onPressed: () async {
                await UserSharedPreferences.setDefaultCountry(myCountry!);
                await UserSharedPreferences.setDefaultCategory(myCategory!);
                await UserSharedPreferences.setThemeColor("#${mycolor.value.toRadixString(16)}");

                print("${myCountry},${myCategory},${mycolor.value.toRadixString(16)}");
                const snackBar = SnackBar(
                  content: Text('Settings Updated'),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                Restart.restartApp();

              },
              child: Text('Done'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
            ),
          ),
        ],
      );
}
