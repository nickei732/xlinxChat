import 'package:flutter/cupertino.dart';

class DarkThemeProvider with ChangeNotifier {
  String _language = "1";
  String _systemTheme = "0";
  String get selectLanguage => _language;

  set selectLanguage(String value) {
    _language = value;
    notifyListeners();
  }
}
