import 'package:get/get.dart';
import 'package:XLINXCHAT/model/room_model.dart';
import 'package:XLINXCHAT/model/user_model.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class PersonDetailsViewModel extends BaseViewModel {
  bool isExpanded = true;
  RoomModel userModel;
  String roomId;

  init(RoomModel userModel, String roomId) async {
    this.userModel = userModel;
    this.roomId = roomId;
  }

  Future<void> blockTap() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Get.back();
    chatRoomService.updateLastMessage({
      "blockBy": prefs.getString("UserId"),
    }, roomId);
  }

  void unBlockTap() {
    Get.back();
    chatRoomService.updateLastMessage({
      "blockBy": null,
    }, roomId);
  }
}
