import 'package:flutter/material.dart';
import 'package:XLINXCHAT/model/ContactList.dart';
import 'package:XLINXCHAT/model/user_model.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/styles.dart';

class UserCard extends StatelessWidget {
  final CategoryData user;
  final Function(CategoryData) onTap;

  UserCard({
    @required this.user,
    @required this.onTap,
    @required this.isSelected,
  });

  final bool isSelected;

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
              //todo
              // image Commented
           /*   Container(
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
                          fontSize: 16,
                          weight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.customerFname,
                        style: AppTextStyle(
                          color: ColorRes.grey.withOpacity(0.5),
                          fontSize: 14,
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
      ),
    );
  }
}
