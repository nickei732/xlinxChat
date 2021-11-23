import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:XLINXCHAT/model/group_model.dart';
import 'package:XLINXCHAT/provider/ColorsInf.dart';
import 'package:XLINXCHAT/screen/broadcast/group_details/group_details_view_model.dart';
import 'package:XLINXCHAT/screen/broadcast/group_details/widgets/members_card.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/app_state.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class GroupDetails extends StatelessWidget {
  final GroupModel groupModel;
  SharedPreferences prefs;
  ColorsInf colorsInf;
  GroupDetails(this.groupModel, this.prefs, this.colorsInf);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GroupDetailsViewModel>.reactive(
      onModelReady: (model) async {
        model.init(groupModel);
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
                                onTap: model.imageClick,
                                child: groupModel.groupImage == null
                                    ? Icon(
                                        Icons.group,
                                        color: ColorRes.dimGray,
                                      )
                                    : FadeInImage(
                                        image:
                                            NetworkImage(groupModel.groupImage),
                                        fit: BoxFit.cover,
                                        placeholder:
                                            AssetImage(AssetsRes.groupImage),
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
                    onPressed: () {
                      Get.back(result: true);
                    },
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
                                groupModel.name,
                                style: AppTextStyle(
                                  fontSize: 18,
                                  color: ColorRes.black,
                                ),
                              ),
                              Text(
                                groupModel.description,
                                style: AppTextStyle(
                                  fontSize: 15,
                                  color: ColorRes.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        groupModel.members
                                .firstWhere((element) =>
                                    element.memberId ==
                                        prefs.getString("UserId"))
                                .isAdmin
                            ? GestureDetector(
                                onTap: model.editTap,
                                child: Icon(
                                  Icons.edit,
                                  color: ColorRes.green,
                                  size: 25,
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                  verticalSpaceSmall,
                  model.isAdmin
                      ? InkWell(
                          onTap: model.addParticipants,
                          child: Container(
                            color: ColorRes.white,
                            height: 50,
                            width: Get.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                horizontalSpaceSmall,
                                Icon(
                                  Icons.person_add,
                                  color: ColorRes.green,
                                  size: 22,
                                ),
                                horizontalSpaceMedium,
                                Text(
                                  "添加参与者",
                                  style: AppTextStyle(
                                    fontSize: 18,
                                    color: ColorRes.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  model.isAdmin ? verticalSpaceSmall : Container(),
                  Container(
                    color: ColorRes.white,
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: MembersCard(
                      groupModel.members,
                      model,
                      prefs,
                      colorsInf
                    ),
                  ),
                  verticalSpaceSmall,
                  InkWell(
                    onTap: () {
                      showConfirmationDialog(
                        model.leftGroupTap,
                        "您确定要离开此群组吗？",
                      );
                    },
                    child: Container(
                      color: ColorRes.white,
                      height: 50,
                      width: Get.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          horizontalSpaceSmall,
                          Icon(
                            Icons.exit_to_app_rounded,
                            color: ColorRes.red,
                            size: 22,
                          ),
                          horizontalSpaceMedium,
                          Text(
                           "离开团队",
                            style: AppTextStyle(
                              fontSize: 18,
                              color: ColorRes.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  verticalSpaceSmall,
                  groupModel.createdBy == prefs.getString("UserId")
                      ? InkWell(
                          onTap: () {
                            showConfirmationDialog(
                              model.deleteGroupTap,
                              "您确定要离开此群组吗？",
                            );
                          },
                          child: Container(
                            color: ColorRes.white,
                            height: 50,
                            width: Get.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                horizontalSpaceSmall,
                                Icon(
                                  Icons.delete_rounded,
                                  color: ColorRes.red,
                                  size: 22,
                                ),
                                horizontalSpaceMedium,
                                Text(
                                  "删除群组",
                                  style: AppTextStyle(
                                    fontSize: 18,
                                    color: ColorRes.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => GroupDetailsViewModel(),
    );
  }
}
