import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:news/utils/app_routes.dart';
import 'package:news/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/utils/shared_preferences.dart';
import 'package:news/views/home_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await UserSharedPreferences.init();
  runApp(
      Phoenix(
          child: ProviderScope(
            child: MyApp(),
          )      ),
    );
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}




class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News',
      theme: Themes.appTheme,
      home: HomePage(),
    );
  }
}