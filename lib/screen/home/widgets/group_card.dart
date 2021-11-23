import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:XLINXCHAT/Colors.dart';
import 'package:XLINXCHAT/model/group_model.dart';
import 'package:XLINXCHAT/model/room_model.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/styles.dart';

class GroupCard extends StatelessWidget {
  final RoomModel groupModel;
  final Function(GroupModel) onTap;
  final int newBadge;
  final String groupType;

  GroupCard(this.groupModel, this.groupType, this.onTap, {this.newBadge = 0});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onTap.call(groupModel.groupModel);
      },
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xff0D9FCC), Color(0xff15255D)],
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              height: size.height*0.053,
              width: size.width*0.11,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: groupModel.groupModel.groupImage == null
                    ? Icon(
                  groupType == "group" ? Icons.group:Icons.record_voice_over,
                  color: ColorRes.white,
                )
                    : FadeInImage(
                  image: NetworkImage(
                    groupModel.groupModel.groupImage,
                  ),
                  height: size.height*0.015,
                  width: size.width*0.015,
                  fit: BoxFit.cover,
                  placeholder: AssetImage(AssetsRes.groupImage),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      groupModel.groupModel.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle(
                        color: ColorRes.black,
                        fontSize: size.width*0.05,
                        weight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height*0.007,),
                    StreamBuilder<DocumentSnapshot>(
                        stream: chatRoomService
                            .streamParticularRoom(groupModel.id),
                        builder: (context, snapshot) {
                          Map<String, dynamic> data = {};
                          if (snapshot.data != null) {
                            data = snapshot.data.data();
                          }
                          String typingId = data['typing_id'];
                          if (snapshot.hasData && typingId != null)
                            return StreamBuilder<DocumentSnapshot>(
                                stream: userService.getUserStream(typingId),
                                builder: (context, childSnap) {
                                  Map<String, dynamic> data = {};
                                  if (childSnap.data != null) {
                                    data = childSnap.data.data();
                                  }
                                    return Text(
                                      groupModel.lastMessage,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyle(
                                        color: ColorRes.grey.withOpacity(0.5),
                                        fontSize: size.width*0.025,
                                        weight: FontWeight.normal,
                                      ),
                                    );
                                });
                          else
                            return Text(
                              groupModel.lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle(
                                color: ColorRes.grey.withOpacity(0.5),
                                fontSize: 14,
                                weight: FontWeight.normal,
                              ),
                            );
                        }),
                    SizedBox(height: size.height*0.025,)

                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(hFormat(groupModel.lastMessageTime)),
                newBadge == 0
                    ? Container()
                // ignore: dead_code
                    : Container(
                  height: 20,
                  width: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorRes.green,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Text(
                    newBadge.toString(),
                    style: AppTextStyle(
                      color: ColorRes.white,
                      fontSize: 14,
                      weight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
