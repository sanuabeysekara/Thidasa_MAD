
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences{
  static SharedPreferences? _preferences;
  static Future init() async => _preferences = await SharedPreferences.getInstance();

  static setDefaultCountry(String country)async{
    await _preferences?.setString('defaultCountry', country);

  }
  static String? getDefaultCountry(){
    return _preferences?.getString('defaultCountry');

  }
  static setDefaultCategory(String category)async{
    await _preferences?.setString('defauletCategory', category);

  }
  static String? getDefaultCategory(){
   return   _preferences?.getString('defauletCategory');

  }
  static setThemeColor(String color)async{
    await _preferences?.setString('defauletColor', color);

  }
  static String? getThemeColor(){
    return  _preferences?.getString('defauletColor');

  }

}