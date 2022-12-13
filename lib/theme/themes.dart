import 'package:flutter/material.dart';
import 'package:gelirgidertakip/items/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier{ //Açık tema ve koyu tema ayarları  //Light theme and dark theme settings
  String currentTheme = 'system';

  ThemeMode get themeMode {
    if(currentTheme == 'light') {
      return ThemeMode.light;
    }else if(currentTheme == 'dark'){
      return ThemeMode.dark;
    }else {
      return ThemeMode.system;
    }
  }

  changeTheme(String theme) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('theme', theme);
    currentTheme = theme;
    notifyListeners();
  }
  initialize() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    currentTheme = _prefs.getString('theme') ?? 'system';
    notifyListeners();
  }

}
class Themes{
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    primarySwatch: Colors.grey,
    colorScheme: ColorScheme.light(),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: ColorsItems().myDarkGrey,
    primaryColor: Colors.black,
    primarySwatch: Colors.grey,
    colorScheme: ColorScheme.dark(),
  );
}
