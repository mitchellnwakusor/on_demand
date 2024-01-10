import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme with ChangeNotifier{
  bool isDarkMode = false;
  void initField() async {
   isDarkMode = await _getSharedPref();
   notifyListeners();
  }


  static ThemeData darkMode = ThemeData.dark().copyWith(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xffffb785),
        onPrimary: Color(0xff502400),
        secondary: Color(0xffffb86f),
        onSecondary: Color(0xff4a2800),
        error: Color(0xffffb4ab),
        onError: Color(0xff690005),
        background: Color(0xff201a17),
        onBackground: Color(0xffece0da),
        surface: Color(0xff201a17),
        onSurface: Color(0xffece0da),
      )
  );

  static ThemeData lightMode = ThemeData.light().copyWith(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xff954a03),
        onPrimary: Color(0xffffffff),
        secondary: Color(0xff8a5100),
        onSecondary: Color(0xffffffff),
        error: Color(0xffba1a1a),
        onError: Color(0xffffffff),
        background: Color(0xfffffbff),
        onBackground: Color(0xff201a17),
        surface: Color(0xfffffbff),
        onSurface: Color(0xff201a17),
      )
  );

  void toggleDarkMode(bool value) {
    isDarkMode = value;
    _setSharedPref(value);
    notifyListeners();
  }
}

void _setSharedPref(bool value) async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setBool('isDarkMode', value);
}

Future<bool> _getSharedPref() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool? value = preferences.getBool('isDarkMode');
  if(value!=null){
    return value;
  }
  else{
    value = false;
    preferences.setBool('isDarkMode',value);
    return value;
  }

}