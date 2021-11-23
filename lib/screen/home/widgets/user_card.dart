import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:XLINXCHAT/model/room_model.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCard extends StatelessWidget {
  final int index;
  SharedPreferences prefs;
  final RoomModel user;
  final Function(RoomModel, String) onTap;
  final bool typing;
  final int newBadge;

  UserCard(this.index, this.prefs, this.user, this.onTap,
      {this.typing = false, this.newBadge = 0});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onTap.call(user, user.id);
      },
      child: Padding(
        padding: const EdgeInsets.all(14),
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              child: Image.asset(
                "assets/images/uicons.png",
                height: size.height*0.01,
                width:  size.height*0.01,
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
                      user.createdBy == prefs.getString("UserId")
                          ? user.membersName[0].toString()
                          : user.membersName[1].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle(
                        color: ColorRes.black,
                        fontSize: size.width*0.05,
                        weight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height*0.007,),

                    typing
                        ? Text(
                            "typing...",
                            style: AppTextStyle(
                              color: ColorRes.green,
                              fontSize: 14,
                            ),
                          )
                        : Text(
                            user.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle(
                              color: ColorRes.grey.withOpacity(0.5),
                              fontSize: size.width*0.04,
                              weight: FontWeight.w600,
                            ),
                          ),
                    SizedBox(height: size.height*0.025,)
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(hFormat(user.lastMessageTime)),
                newBadge == 0
                    ? Container()
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
