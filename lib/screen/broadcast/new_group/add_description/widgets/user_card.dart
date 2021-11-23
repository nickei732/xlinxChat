import 'package:flutter/material.dart';
import 'package:XLINXCHAT/model/ContactList.dart';
import 'package:XLINXCHAT/model/user_model.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/styles.dart';

class UserCard extends StatelessWidget {
  CategoryData user;

  UserCard({
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //todo
          // image Commented
    /*      Container(
            height: 40,
            width: 40,
            margin: EdgeInsets.only(bottom: 3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.network(
                user.profileImage,
                height: 40,
                width: 40,
              ),
            ),
          ),*/
          Text(
            user.customerFname.split(" ").first,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle(
              color: ColorRes.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
