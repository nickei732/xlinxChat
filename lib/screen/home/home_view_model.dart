import 'package:get/get.dart';
import 'package:XLINXCHAT/model/group_model.dart';
import 'package:XLINXCHAT/model/room_model.dart';
import 'package:XLINXCHAT/model/user_model.dart';
import 'package:XLINXCHAT/provider/ColorsInf.dart';
import 'package:XLINXCHAT/screen/broadcast/new_group/select_member/select_members.dart';
import 'package:XLINXCHAT/screen/person/chat_screen/chat_screen.dart'
    as Person;
import 'package:XLINXCHAT/screen/group/chat_screen/chat_screen.dart'
    as Group;
import 'package:XLINXCHAT/screen/broadcast/chat_screen/chat_screen.dart'
    as broadcast;
import 'package:XLINXCHAT/screen/group/new_group/select_member/select_members.dart';
import 'package:XLINXCHAT/screen/person/settings/setting.dart';
import 'package:XLINXCHAT/screen/broadcast/new_group/select_member/select_members.dart';
import 'package:XLINXCHAT/service/auth_service/auth_service.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  void init() async {

    setBusy(true);
/*    appState.currentUser =
        await userService.getUserModel("90302099");
    final fcmToken = await messagingService.getFcmToken();
    await userService
        .updateUser("90302099", {"fcmToken": fcmToken});*/
    setBusy(false);
  }

  gotoSettingPage(ColorsInf colorsInf) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Get.to(() => SettingDetails(prefs,colorsInf));
  }

  onUserCardTap(RoomModel userModel, String roomId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Get.to(() => Person.ChatScreen(userModel, true, roomId,prefs));
  }

  void createGroupClick() {
    Get.to(() => SelectMembers(true,false));
  }

  void personalChatClick() {
    Get.to(() => SelectMembers(false,false));
  }
  void createBroadcastClick() {
    Get.to(() => SelectMembersBroadcast(true,false));
  }
  void groupClick(GroupModel groupModel) {
    print("Group click");
    Get.to(() => Group.ChatScreen(groupModel, true));
  }
  void broadcastClick(GroupModel groupModel) {
    print("Broadcast click");
    Get.to(() => broadcast.ChatScreen(groupModel, true));
  }
}
