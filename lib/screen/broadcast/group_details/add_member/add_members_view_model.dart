import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:XLINXCHAT/model/ContactList.dart';
import 'package:XLINXCHAT/model/group_model.dart';
import 'package:XLINXCHAT/model/message_model.dart';
import 'package:XLINXCHAT/model/room_model.dart';
import 'package:XLINXCHAT/model/send_notification_model.dart';
import 'package:XLINXCHAT/model/user_model.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class AddMembersViewModel extends BaseViewModel {
  List<UserModel> users;
  List<CategoryData> selectedMembers = [];
  GroupModel groupModel;
  List<String> membersId = [];

  init(GroupModel groupModel) async {
    this.groupModel = groupModel;

    setBusy(true);
    QuerySnapshot querySnapshot = await userService.getUsers();
    if (querySnapshot.docs.isNotEmpty) {
      users =
          querySnapshot.docs.map((e) => UserModel.fromMap(e.data())).toList();
    } else {
      users = [];
    }

    if (users.isNotEmpty) {
      groupModel.members.forEach((mem) {
        membersId.add(mem.memberId);
        users.removeWhere((element) => element.uid == mem.memberId);
      });
    }
    setBusy(false);
  }

  void sendMessage(String type, String content, MMessage message) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    print("calling broadcast");
    DateTime messageTime = DateTime.now();
    DocumentSnapshot roomDocument;
    List<CategoryData> members = [];

    for (var value in groupModel.members) {
      CategoryData doc = await userService.contactList(value.memberId);
      members.add(doc);
    }
    MessageModel messageModel = MessageModel(
      content: content,
      sender: prefs.getString("UserId"),
      sendTime: messageTime.millisecondsSinceEpoch,
      type: type,
      receiver: groupModel.groupId,
      mMessage: message,
      senderImage: "",
      senderName: prefs.getString("Username"),
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

  Future<void> nextClick() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (selectedMembers.isEmpty) {
      Get.back();
    } else {
      setBusy(true);
      List<String> fcmTokens = [];
      selectedMembers.forEach((element) {
       // fcmTokens.add(element.fcmToken);
        membersId.add(element.customerId);
        groupModel.members.add(GroupMember(
          isAdmin: false,
          memberId: element.customerId,
          memberName: element.customerFname,

        ));
      });
/*      fcmTokens
          .removeWhere((element) => (element ==  prefs.getString("token")));*/
      groupService.updateGroupMember(groupModel.groupId,
          List<dynamic>.from(groupModel.members.map((x) => x.toMap())));
      chatRoomService.updateGroupMembers(groupModel.groupId, membersId);

      selectedMembers.forEach((element) async {
        chatRoomService.updateGroupNewMessage(groupModel.groupId, element.customerId);
        sendMessage('alert', '${element.customerFname} added', null);
      });

      selectedMembers.forEach((element) {
        chatRoomService.updateGroupNewMessage(groupModel.groupId, element.customerId);
      });

      //todo notifications
 /*     messagingService.sendNotification(
        SendNotificationModel(
          fcmTokens: fcmTokens,
          roomId: groupModel.groupId,
          id: groupModel.groupId,
          body: "Tap here to chat",
          title:
              "${appState.currentUser.name} add you into a group ${groupModel.name}",
          isGroup: false,
        ),
      );*/
      Get.back(result: groupModel);
    }
  }

  bool isSelected(CategoryData userModel) {
    return selectedMembers.contains(userModel);
  }

  void selectUserClick(CategoryData user) async {
    if (selectedMembers.contains(user))
      selectedMembers.remove(user);
    else
      selectedMembers.add(user);

    notifyListeners();
  }
}
