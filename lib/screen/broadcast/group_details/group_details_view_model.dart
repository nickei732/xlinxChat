import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:XLINXCHAT/model/ContactList.dart';
import 'package:XLINXCHAT/model/group_model.dart';
import 'package:XLINXCHAT/model/message_model.dart';
import 'package:XLINXCHAT/model/room_model.dart';
import 'package:XLINXCHAT/model/user_model.dart';
import 'package:XLINXCHAT/provider/ColorsInf.dart';
import 'package:XLINXCHAT/screen/broadcast/group_details/add_member/add_members.dart';
import 'package:XLINXCHAT/screen/broadcast/group_details/widgets/dialog_view.dart';
import 'package:XLINXCHAT/screen/home/home_screen.dart';
import 'package:XLINXCHAT/screen/person/chat_screen/chat_screen.dart';
import 'package:XLINXCHAT/screen/person/person_details/person_details.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/app_state.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/exception.dart';
import 'package:XLINXCHAT/utils/collections.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class GroupDetailsViewModel extends BaseViewModel {
  bool isExpanded = true;
  bool isAdmin = false;
  GroupModel groupModel;
  List<CategoryData> members = [];
  List<String> membersId = [];

  final ImagePicker picker = ImagePicker();

  bool imageLoader = false;

  init(GroupModel groupModel) async {
    this.groupModel = groupModel;
    for (var value in groupModel.members) {
      CategoryData doc = await userService.contactList(value.memberId);
      members.add(doc);
    }
    chackCurrentUserIsAdmin();
    getMembersId();
  }

  void getMembersId() {
    membersId = groupModel.members.map((element) {
      return element.memberId;
    }).toList();
  }

  Future<void> chackCurrentUserIsAdmin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    groupModel.members.forEach((element) {
      if (element.memberId == prefs.getString("UserId")) {
        isAdmin = element.isAdmin;
      }
    });
    notifyListeners();
  }

  void sendMessage(String type, String content, MMessage message) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("calling broadcast");
    DateTime messageTime = DateTime.now();
    DocumentSnapshot roomDocument;

    MessageModel messageModel = MessageModel(
      content: content,
      sender: prefs.getString("UserId"),
      sendTime: messageTime.millisecondsSinceEpoch,
      type: type,
      receiver: groupModel.groupId,
      mMessage: message,
      senderImage: "",
      senderName:prefs.getString("Username"),
    );

    roomDocument = await chatRoomService.getParticularRoom(groupModel.groupId);

    String notificationBody;
    switch (type) {
      case "text":
        notificationBody = content;
        break;
      case "photo":
        notificationBody = "📷 Image";
        break;
      case "document":
        notificationBody = "📄 Document";
        break;
      case "music":
        notificationBody = "🎵 Music";
        break;
      case "video":
        notificationBody = "🎥 Video";
        break;
      case "alert":
        notificationBody = content;
        break;
    }
    print("-----------------------------------");
    membersId.forEach((element) {
      print("Element::::$element");
      chatRoomService.sendMessage(
          messageModel, "${prefs.getString("UserId")}-$element");
    });
    chatRoomService.sendMessage(messageModel, groupModel.groupId);
    Map<String, dynamic> updateData = {};
    List<int> count = [];

    membersId.forEach((element) {
      count.add(roomDocument.get("${element}_newMessage"));
    });

    for (int i = 0; i < count.length; i++) {
      updateData['${membersId[i]}_newMessage'] = (count[i].toInt()) + 1;
    }

    updateData["lastMessage"] = notificationBody;
    updateData["lastMessageTime"] = messageTime;

    chatRoomService.updateLastMessage(
      updateData,
      groupModel.groupId,
    );
    membersId.forEach((element) {
      chatRoomService.updateLastMessage(
        updateData,
        "${prefs.getString("UserId")}-$element",
      );
    });
  }

  Future<void> leftGroupTap() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> adminId = [];
    groupModel.members.forEach((element) {
      if (element.isAdmin) {
        adminId.add(element.memberId);
      }
    });

    if (adminId.length == 1 && isAdmin == true) {
      Get.back();
      Get.snackbar(
        "Alert",
        "Please! create admin of another group-member for left the group",
        duration: Duration(seconds: 5),
        backgroundColor: ColorRes.red,
        colorText: ColorRes.white,
        icon: Icon(
          Icons.cancel,
          color: ColorRes.white,
          size: 32,
        ),
      );
    } else {
      groupModel.members.remove(groupModel.members.firstWhere(
          (element) => element.memberId == prefs.getString("UserId")));
      members.removeWhere((element) => element.customerId == prefs.getString("UserId"));
      if (groupModel.members.isEmpty) {
        deleteGroupTap();
        return;
      }
      List<String> membersId =
          groupModel.members.map((e) => e.memberId).toList();
      this.membersId = membersId;
      groupService.updateGroupMember(groupModel.groupId,
          List<dynamic>.from(groupModel.members.map((x) => x.toMap())));
      chatRoomService.updateGroupMembers(groupModel.groupId, membersId);

      await removeNewMessageStr(prefs.getString("UserId")).then((value) async {
        UserModel user =
            await userService.getUserModel(prefs.getString("UserId"));
        sendMessage('alert', "${user.name} left", null);
      });
      Get.offAll(() => HomeScreen());
    }
  }

  void deleteGroupTap() {
    groupService.deleteGroup(groupModel.groupId);
    chatRoomService.deleteChatRoom(groupModel.groupId);
    Get.offAll(() => HomeScreen());
  }
// todo
  void infoTap(GroupMember member) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    UserModel userModel = await userService.getUserModel(member.memberId);
    appState.currentActiveRoom = null;
 //   await Get.to(() => PersonDetails(userModel, null,prefs));
    appState.currentActiveRoom = groupModel.groupId;
  }

  void makeAdminTap(GroupMember member) {
    int index = groupModel.members.indexOf(member);
    groupModel.members[index].isAdmin = true;
    groupService.updateGroupMember(groupModel.groupId,
        List<dynamic>.from(groupModel.members.map((x) => x.toMap())));
    notifyListeners();
  }

  void removeAdminTap(GroupMember member) {
    int index = groupModel.members.indexOf(member);
    groupModel.members[index].isAdmin = false;
    groupService.updateGroupMember(groupModel.groupId,
        List<dynamic>.from(groupModel.members.map((x) => x.toMap())));
    notifyListeners();
  }

  Future<void> removeFromGroupTap(GroupMember member) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    groupModel.members.remove(member);
    members.removeWhere((element) => element.customerId == member.memberId);
    List<String> membersId = groupModel.members.map((e) => e.memberId).toList();
    this.membersId = membersId;
    groupService.updateGroupMember(groupModel.groupId,
        List<dynamic>.from(groupModel.members.map((x) => x.toMap())));
    chatRoomService
        .updateGroupMembers(groupModel.groupId, membersId)
        .then((value) async {
      await removeNewMessageStr(member.memberId).then((value) async {
      /*  UserModel user1 =
            await userService.getUserModel(prefs.getString("UserId"));
        UserModel user2 = await userService.getUserModel(member.memberId);*/
        sendMessage('alert', "${member.memberName} removed", null);
      });
    });
    notifyListeners();
  }

  Future<void> removeNewMessageStr(String userId) async {
    CollectionReference chatRoom =
        FirebaseFirestore.instance.collection(Collections.chatRoom);

    await chatRoom
        .doc(groupModel.groupId)
        .update({'${userId}_newMessage': FieldValue.delete()});
  }
// todo
  void sendMessageTap(GroupMember member) async {
  /*  final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      RoomModel userModel = await userService.getUserModel(member.memberId);
      String chatId = '';
      if (userModel.uid.hashCode <= prefs.getString("UserId").hashCode) {
        chatId = '${userModel.uid}-${prefs.getString("UserId")}';
      } else {
        chatId = '${prefs.getString("UserId")}-${userModel.uid}';
      }
      DocumentSnapshot doc = await chatRoomService.isRoomAvailable(chatId);
      appState.currentActiveRoom = chatId;
      await Get.to(
          () => ChatScreen(userModel, true, doc.exists ? chatId : null));
      appState.currentActiveRoom = groupModel.groupId;
    } catch (e) {}*/
  }

  void updateGroupTap(String title, String desc) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    groupModel.name = title;
    groupModel.description = desc;

    await groupService.getGroup(groupModel.groupId).then((value) async {
      Map<String, dynamic> data = value.data();
      String oldGroupName = data['name'];

      if (oldGroupName != title) {
        UserModel user =
            await userService.getUserModel(prefs.getString("UserId"));
        sendMessage(
            'alert',
            "${user.name} changed the subject from $oldGroupName to $title",
            null);
      }
    });

    groupService.updateGroupDesc(groupModel.groupId, title, desc);
    notifyListeners();
  }

  void editTap() {
    Get.dialog(
      Dialog(
        child: GroupInfoDialog(
          groupModel.name,
          groupModel.description,
          updateGroupTap,
        ),
      ),
    );
  }

  void groupMembersTap(
    GroupMember member,
    bool isAdmin,
    GroupDetailsViewModel model,
      ColorsInf colorsInf
  ) {
    Get.dialog(
      Dialog(
        child: GroupMemberDialog(
          member,
          isAdmin,
          groupModel,
          model,
          colorsInf
        ),
      ),
    );
  }

  void addParticipants() async {
    final data = await Get.to(() => AddMembers(groupModel));
    if (data != null) {
      groupModel = data as GroupModel;
      notifyListeners();
    }
  }

  void imageClick() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageLoader = true;
        notifyListeners();
        String imageUrl =
            await storageService.uploadGroupIcon(File(pickedFile.path));
        if (imageUrl != null) {
          groupModel.groupImage = imageUrl;
          groupService.updateGroup(
            groupModel.groupId,
            {"groupImage": imageUrl},
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
