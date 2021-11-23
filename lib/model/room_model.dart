import 'package:XLINXCHAT/model/group_model.dart';
import 'package:XLINXCHAT/model/user_model.dart';

class RoomModel {
  String id;
  String lastMessage;
  List<String> membersId;
  List<String> membersName;
  String memberImage;
  String senderImage;
  String createdBy;
  String fcmToken;
  DateTime lastMessageTime;
  bool isGroup;
  GroupModel groupModel;
  UserModel userModel;

  RoomModel(
      {this.id,
      this.lastMessage,
      this.lastMessageTime,
      this.isGroup,
      this.memberImage,
      this.membersId,
      this.fcmToken,
      this.membersName,
      this.senderImage});

  factory RoomModel.fromMap(Map<String, dynamic> data) => RoomModel(
      id: data['id'],
      lastMessageTime: data['lastMessageTime'].toDate(),
      lastMessage: data['lastMessage'],
      isGroup: data['isGroup'],
      membersId: data['membersId'].cast<String>(),
      membersName: data['membersName'].cast<String>(),
      memberImage: data['memberImage'],
      fcmToken: data['fcmToken'],
      senderImage: data['senderImage']);
}
