import 'package:flutter/material.dart';

import '../utils/extensions.dart';
import '../utils/shared_preferences.dart';

class AppColors {
  AppColors._();
  //static const gotcolor = UserSharedPreferences.getThemeColor();
  static const Color orangeWeb = Color(0xFFf59400);
  static const Color white = Color(0xFFf5f5f5);
  static const Color lightGrey = Color(0xFFd2d7df);
  static  Color burgundy =  UserSharedPreferences.getThemeColor() == null ?Color(0xff07145e) : ColorExtension.toColor(UserSharedPreferences.getThemeColor()!);
}
