import 'package:flutter/material.dart';
import 'package:XLINXCHAT/model/room_model.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/styles.dart';

class UserCard extends StatelessWidget {
  final RoomModel user;
  final bool isSelected;
  final Function(RoomModel) onTap;

  UserCard(
    this.user,
    this.onTap,
    this.isSelected,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call(user);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset(
                    AssetsRes.profileImage,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    user.membersName[1].toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle(
                      color: ColorRes.black,
                      fontSize: 16,
                      weight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              isSelected
                  ? Icon(
                      Icons.check_circle,
                      color: ColorRes.green,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
