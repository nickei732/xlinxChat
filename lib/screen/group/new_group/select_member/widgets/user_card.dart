import 'package:flutter/material.dart';
import 'package:XLINXCHAT/model/ContactList.dart';
import 'package:XLINXCHAT/model/user_model.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/styles.dart';

class UserCard extends StatelessWidget {
  final Function(CategoryData) onTap;
  CategoryData user;
  UserCard({
    @required this.onTap,
    @required this.isSelected, this.user,
  });

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
      onTap.call(user);
      },
      child: Padding(
        padding: const EdgeInsets.all(6),
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
            //todo
            // image Commented
           /* Container(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: FadeInImage(
                  image: NetworkImage(user.profileImage),
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  placeholder: AssetImage(AssetsRes.profileImage),
                ),
              ),
            ),*/
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.customerEmail,
                      style: AppTextStyle(
                        color: ColorRes.black,
                        fontSize: size.width*0.05,
                        weight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.035,
                    ),
                    Text(
                      user.customerFname,
                      style: AppTextStyle(
                        color: ColorRes.black,
                        fontSize: size.width*0.035,
                        weight: FontWeight.normal,
                      ),
                    ),

                  ],
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
    );
  }
}
