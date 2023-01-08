import 'package:news/constants/color_constants.dart';
import 'package:flutter/material.dart';

class Themes {
  static final appTheme = ThemeData(
    primaryColor: AppColors.thidasaDarkBlue,
    scaffoldBackgroundColor: AppColors.thidasaDarkBlue,
    buttonTheme: const ButtonThemeData(buttonColor: AppColors.orangeWeb),
    appBarTheme:  AppBarTheme(backgroundColor: AppColors.thidasaDarkBlue),
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: AppColors.orangeWeb),
  );
}
