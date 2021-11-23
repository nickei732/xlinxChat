import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:XLINXCHAT/model/message_model.dart';
import 'package:XLINXCHAT/model/room_model.dart';
import 'package:XLINXCHAT/model/send_notification_model.dart';
import 'package:XLINXCHAT/model/user_model.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class ForwardViewModel extends BaseViewModel {
  List<RoomModel> rooms = [];
  List<RoomModel> selectedMembers = [];
  List<MessageModel> messages;

  init(List<MessageModel> messages) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    this.messages = messages;
    setBusy(true);
    QuerySnapshot querySnapshot = await chatRoomService.getAllRooms(prefs);
    if (querySnapshot.docs.isNotEmpty) {
      rooms =
          querySnapshot.docs.map((e) => RoomModel.fromMap(e.data())).toList();
    }
    setBusy(false);
  }

  Future<void> nextClick() async {
    if (selectedMembers.isEmpty) {
      showErrorToast(AppRes.select_at_least_one_person);
    } else {
      setBusy(true);
      for (var member in selectedMembers) {
        for (var message in messages) {
          await sendMessage(message, member);
        }
      }
      setBusy(false);
      Get.back(result: true);
    }
  }

  bool isSelected(RoomModel userModel) {
    return selectedMembers.contains(userModel);
  }

  void selectUserClick(RoomModel user) async {
    if (selectedMembers.contains(user))
      selectedMembers.remove(user);
    else
      selectedMembers.add(user);

    notifyListeners();
  }

  Future<void> sendMessage(
      MessageModel messageModel, RoomModel roomModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    DateTime messageTime = DateTime.now();
    messageModel.sendTime = messageTime.millisecondsSinceEpoch;
    messageModel.sender = prefs.getString("UserId");
    messageModel.senderName = prefs.getString("Username");
    messageModel.senderImage="";
    messageModel.mMessage = MMessage(mType: Type.forward);
    //todo notification
    /*String notificationBody;
    switch (messageModel.type) {
      case "text":
        notificationBody = messageModel.content;
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
    }

    SendNotificationModel notificationModel;*/

    //todo

   /* if (roomModel.isGroup) {
      List<String> fcms = [];
      for (var value in roomModel.groupModel.members) {
        if (value.memberId != prefs.getString("UserId")) {
          UserModel doc = await userService.getUserModel(value.memberId);
          fcms.add(doc.fcmToken);
        }
      }
      fcms.removeWhere((element) => (element ==  prefs.getString("token")));
      notificationModel = SendNotificationModel(
        isGroup: false,
        title: prefs.getString("Username"),
        body: notificationBody,
        fcmTokens: fcms,
        roomId: roomModel.id,
        id: prefs.getString("UserId"),
      );
    } else {
      notificationModel = SendNotificationModel(
        isGroup: false,
        title: prefs.getString("Username"),
        body: notificationBody,
       // fcmToken: roomModel.userModel.fcmToken,
        roomId: roomModel.id,
        id: prefs.getString("UserId"),
      );
    }*/

    chatRoomService.sendMessage(messageModel, roomModel.id);
  /*  chatRoomService.updateLastMessage(
      {"lastMessage": notificationBody, "lastMessageTime": messageTime},
      roomModel.id,
    );*/

  /*  if(roomModel.isGroup){
      messagingService.sendNotification(notificationModel);
    }else{
      // ignore: unnecessary_statements
      (roomModel.userModel.fcmToken !=  prefs.getString("token")) ? messagingService.sendNotification(notificationModel) : null;
    }*/
  }
}
