import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:XLINXCHAT/model/group_model.dart';
import 'package:XLINXCHAT/provider/ColorsInf.dart';
import 'package:XLINXCHAT/screen/person/settings/widget/dialog_view.dart';
import 'package:XLINXCHAT/service/auth_service/auth_service.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/app_state.dart';
import 'package:XLINXCHAT/utils/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import '../../IntroScreensWithLogin/SplashScreen1.dart';

class SettingViewModel extends BaseViewModel {
  bool isExpanded = true;

  GroupModel groupModel;

  final ImagePicker picker = ImagePicker();

  bool imageLoader = false;

  init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
/*    appState.currentUser =
        await userService.getUserModel(prefs.getString("UserId"));*/
  }

  void updateNameTap(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    appState.currentUser.name = name;
    userService.updateUser(
      prefs.getString("UserId"),
      {"name": name},
    );
    notifyListeners();
  }

  void editTap() {
    Get.dialog(
      Dialog(
        child: PersonInfoDialog(
          appState.currentUser.name,
          updateNameTap,
        ),
      ),
    );
  }

  logoutTap(ColorsInf colorsInf) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLogging", false);
    try {
      showConfirmationDialog(
        () async {
          await authService.logout();
          Get.offAll(() => SplashScreen1());
        },
        "Are you sure you want logout?",
      );
    } catch (e) {}
  }

  void imageClick() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageLoader = true;
        notifyListeners();
        String imageUrl =
            await storageService.uploadGroupIcon(File(pickedFile.path));
        if (imageUrl != null) {
          appState.currentUser.profilePicture = imageUrl;
          userService.updateUser(
            prefs.getString("UserId"),
            {"profilePicture": imageUrl},
          );
        }
        imageLoader = false;
        notifyListeners();
      }
    } catch (e) {
      handleException(e);
    }
  }
}
