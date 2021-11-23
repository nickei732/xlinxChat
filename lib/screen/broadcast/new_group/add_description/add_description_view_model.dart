import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:XLINXCHAT/model/ContactList.dart';
import 'package:XLINXCHAT/model/group_model.dart';
import 'package:XLINXCHAT/model/send_notification_model.dart';
import 'package:XLINXCHAT/model/user_model.dart';
import 'package:XLINXCHAT/screen/home/home_screen.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/app_state.dart';
import 'package:XLINXCHAT/utils/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class AddDescriptionViewModel extends BaseViewModel {
  List<CategoryData> members;

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File image;

  final ImagePicker picker = ImagePicker();

  init(List<CategoryData> users) async {
    setBusy(true);
    this.members = users;
    setBusy(false);
  }

  void doneClick() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Get.focusScope.unfocus();
    if (formKey.currentState.validate()) {
      setBusy(true);

      GroupModel groupModel = GroupModel()..members = [];

      groupModel.name = title.text.trim();
      groupModel.description = "ConfirmBroadcast";

      List<String> membersId = [];
      List<String> membersName = [];

      members.forEach((element) {
        groupModel.members.add(GroupMember(
          memberId: element.customerId.toString(),
          memberName: element.customerFname.toString(),
          memberImage: "",
          isAdmin: false,
        ));
        membersId.add(element.customerId.toString());
        membersName.add(element.customerFname.toString());

      });

      membersId.add(prefs.getString("UserId"));
      membersName.add(prefs.getString("Username"));


      groupModel.members.insert(
          0,
          GroupMember(
            memberId: prefs.getString("UserId"),
            memberName:prefs.getString("Username") ,
            memberImage:"",
            isAdmin: true,
          ));

      if (image == null) {
        groupModel.groupImage = null;
      } else {
        String imageUrl = await storageService.uploadGroupIcon(image);
        if (imageUrl == null) {
          groupModel.groupImage = null;
        } else {
          groupModel.groupImage = imageUrl;
        }
      }

      groupModel.createdAt = DateTime.now();
      groupModel.createdBy = prefs.getString("UserId");

      try {
        DocumentReference groupData =
            await groupService.createGroup(groupModel);
        Map<String, dynamic> data = {
          "isGroup": true,
          "id": groupData.id,
          "membersId": membersId,
          "membersName":membersName,
          "lastMessage": "Tap here",
          "lastMessageTime": DateTime.now(),
          'typing_id': null,
        };
        membersId.forEach((element) {
          data['${element}_newMessage'] = 1;
        });

       /* List<String> tokenList = members.map((e) => e.uid.toString()).toList();
        tokenList.removeWhere((element) => (element ==  prefs.getString("token")));
*/
        await chatRoomService.createChatRoom(data);
        membersId.remove(prefs.getString("UserId"));
        membersName.remove(prefs.getString("Username"));


        //todo
        /*    messagingService.sendNotification(
          SendNotificationModel(
            fcmTokens: tokenList,
            roomId: groupData.id,
            id: groupData.id,
            body: "Tap here to chat",
            title:
                "${prefs.getString('Username')} create a group ${groupModel.name}",
            isGroup: false,
          ),
        );*/
        Get.offAll(() => HomeScreen("broadcast"));
      } catch (e) {}
      setBusy(false);
    }
  }

  void imagePick() async {
    Get.focusScope.unfocus();
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        image = File(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      handleException(e);
    }
  }
}
