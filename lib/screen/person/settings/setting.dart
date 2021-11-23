import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:XLINXCHAT/provider/ColorsInf.dart';
import 'package:XLINXCHAT/screen/person/settings/setting_view_model.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/app_state.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

class SettingDetails extends StatelessWidget {
  SharedPreferences prefs;
  ColorsInf colorsInf;
  SettingDetails(this.prefs, this. colorsInf);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      onModelReady: (model) async {
        model.init();
      },
      builder: (context, model, child) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (_, __) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 200.h,
                  floating: false,
                  pinned: true,
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      model.isExpanded = constraints.biggest.height != 80;
                      return FlexibleSpaceBar(
                        background: model.imageLoader
                            ? Center(
                                child: Platform.isIOS
                                    ? CupertinoActivityIndicator()
                                    : CircularProgressIndicator(),
                              )
                            : InkWell(
                                //onTap: model.imageClick,
                                child: prefs.getString('profilePhoto') ==
                                        null
                                    ? Icon(
                                        Icons.group,
                                        color: ColorRes.dimGray,
                                      )
                                    : FadeInImage(
                                  image: AssetImage(AssetsRes.profileImage),
                                  fit: BoxFit.cover,
                                        placeholder:
                                            AssetImage(AssetsRes.profileImage),
                                      ),
                              ),
                      );
                    },
                  ),
                  backgroundColor: ColorRes.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(
                      Platform.isIOS
                          ? Icons.arrow_back_ios_rounded
                          : Icons.arrow_back_rounded,
                      color: ColorRes.dimGray,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
              ];
            },
            body: SingleChildScrollView(
              child: Column(
                children: [
                  verticalSpaceSmall,
                  Container(
                    color: ColorRes.white,
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prefs.getString('Username'),
                                style: AppTextStyle(
                                  fontSize: 18,
                                  color: ColorRes.black,
                                ),
                              ),
                              Text("这不是您的用户名或密码。您的联系人将可以看到此名称",
                                style: AppTextStyle(
                                  fontSize: 14,
                                  color: ColorRes.dimGray.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                    /*    GestureDetector(
                          onTap: model.editTap,
                          child: Icon(
                            Icons.edit,
                            color: ColorRes.green,
                            size: 25,
                          ),
                        )*/
                      ],
                    ),
                  ),
                  verticalSpaceSmall,
                  InkWell(
                    onTap: (){model.logoutTap(colorsInf);},
                    child: Container(
                      color: ColorRes.white,
                      width: Get.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      child: Row(
                        children: [
                          Icon(
                            Icons.exit_to_app_rounded,
                            color: ColorRes.green,
                            size: 25,
                          ),
                          horizontalSpaceMedium,
                          Text(
                            "登出",
                            style: AppTextStyle(
                              fontSize: 18,
                              color: ColorRes.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => SettingViewModel(),
    );
  }
}
