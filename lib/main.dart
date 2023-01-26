import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:news/utils/app_routes.dart';
import 'package:news/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/utils/shared_preferences.dart';
import 'package:news/views/home_page.dart';
import 'package:news/views/navigation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'constants/color_constants.dart';

void main() async{

  await FlutterDownloader.initialize(
      debug: true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl: true // option: set to false to disable working with http links (default: false)
  );

  ErrorWidget.builder = (FlutterErrorDetails details) {
    bool inDebug = false;
    assert(() { inDebug = true; return true; }());
    // In debug mode, use the normal error widget which shows
    // the error message:
    if (inDebug)
      return ErrorWidget(details.exception);
    // In release builds, show a yellow-on-blue message instead:
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Error! ${details.exception}',
        style: TextStyle(color: Colors.yellow),
        textDirection: TextDirection.ltr,
      ),
    );
  };


  WidgetsFlutterBinding.ensureInitialized();
  await UserSharedPreferences.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) =>   runApp(Phoenix(child: ProviderScope(child: MyApp(),)),));
  runApp(Phoenix(child: ProviderScope(child: MyApp(),)),);
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
      theme: ThemeData(
        primaryColor: AppColors.thidasaDarkBlue,
        scaffoldBackgroundColor: AppColors.thidasaDarkBlue,
        brightness: Brightness.light,
        buttonTheme: const ButtonThemeData(buttonColor: AppColors.orangeWeb),
        appBarTheme:  AppBarTheme(backgroundColor: AppColors.thidasaDarkBlue),
        colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: AppColors.orangeWeb),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        dividerColor: Colors.transparent,/* light theme settings */
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      home:
      WillPopScope(
          onWillPop: ()  {

              return Future.value(false);

          },
          child: NavigationController()
      ),
    );
  }
}