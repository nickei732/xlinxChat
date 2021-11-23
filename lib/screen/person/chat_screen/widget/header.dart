import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:XLINXCHAT/model/room_model.dart';
import 'package:XLINXCHAT/model/user_model.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Header extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback headerClick;
  final RoomModel userModel;
  final bool isForwardMode;
  final bool isDeleteMode;
  final VoidCallback deleteClick;
  final VoidCallback forwardClick;
  final VoidCallback clearClick;
  final bool typing;
  SharedPreferences prefs;
  Header( {
    @required this.onBack,
    @required this.headerClick,
    @required this.userModel,
    this.isDeleteMode,
    this.isForwardMode,
    this.deleteClick,
    this.forwardClick,
    this.clearClick,
    this.typing,
    this.prefs
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: ColorRes.white,
        ),
        height: 60,
        child: Row(
          children: [
            isDeleteMode || isForwardMode
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 13),
                    child: InkWell(
                      onTap: clearClick,
                      child: Icon(
                        Icons.clear,
                        color: ColorRes.dimGray,
                      ),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 13),
                    child: InkWell(
                      onTap: onBack,
                      child: Icon(
                        Platform.isIOS
                            ? Icons.arrow_back_ios
                            : Icons.arrow_back,
                        color: ColorRes.dimGray,
                      ),
                    ),
                  ),
            Expanded(
              child: InkWell(
                onTap: () {
                  headerClick.call();
                },
                child: Container(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: FadeInImage(
                            image: AssetImage(AssetsRes.profileImage),
                            height: 30,
                            width: 30,
                            fit: BoxFit.cover,
                            placeholder: AssetImage(AssetsRes.profileImage),
                          ),
                        ),
                      ),
                      horizontalSpaceSmall,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              userModel.createdBy == prefs.getString("UserId")
                                  ? userModel.membersName[0].toString()
                                  : userModel.membersName[1].toString(),
                              style: AppTextStyle(
                                color: ColorRes.dimGray,
                                fontSize: 16,
                              ),
                            ),
                            if (typing != null && typing)
                              Text(
                                "typing...",
                                style: AppTextStyle(
                                  color: ColorRes.green,
                                  fontSize: 14,
                                ),
                              )
                            else
                              Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            isDeleteMode
                ? IconButton(
                    onPressed: deleteClick,
                    icon: Icon(
                      Icons.delete_rounded,
                      color: ColorRes.green,
                    ),
                  )
                : isForwardMode
                    ? IconButton(
                        onPressed: forwardClick,
                        icon: Icon(
                          Icons.fast_forward_rounded,
                          color: ColorRes.green,
                        ),
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }
}
