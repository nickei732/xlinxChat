import 'package:XLINXCHAT/model/user_model.dart';

class AppState {
  static final AppState _singleton = AppState._internal();

  factory AppState() {
    return _singleton;
  }

  AppState._internal();

  UserModel currentUser;

  String currentActiveRoom;
}

AppState appState = AppState();
