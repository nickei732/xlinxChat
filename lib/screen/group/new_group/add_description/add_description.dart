import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'package:XLINXCHAT/model/ContactList.dart';
import 'package:XLINXCHAT/model/user_model.dart';
import 'package:XLINXCHAT/screen/group/new_group/add_description/add_description_view_model.dart';
import 'package:XLINXCHAT/screen/group/new_group/add_description/widgets/description_area.dart';
import 'package:XLINXCHAT/screen/group/new_group/add_description/widgets/user_card.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class AddDescription extends StatefulWidget {
  final List<CategoryData> members;
  AddDescription(this.members);

  @override
  _AddDescriptionState createState() => _AddDescriptionState();
}
class _AddDescriptionState extends State<AddDescription> {
  bool isLogin=false;
  CategoryList categoryList;
  List<CategoryData> categoryDataList = [];

  @override
  void initState() {
    // TODO: implement initState
    getContactList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddDescriptionViewModel>.reactive(
      onModelReady: (model) async {
        model.init(widget.members);
      },
      viewModelBuilder: () => AddDescriptionViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorRes.background,
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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppRes.newGroup,
                  style: AppTextStyle(
                    color: ColorRes.dimGray,
                    weight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  AppRes.add_description,
                  style: AppTextStyle(
                    color: ColorRes.dimGray,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          body: model.isBusy
              ? Center(
                  child: Platform.isIOS
                      ? CupertinoActivityIndicator()
                      : CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/page4bg.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: [
                        DescriptionArea(
                          title: model.title,
                          description: model.description,
                          image: model.image,
                          imagePick: model.imagePick,
                          formKey: model.formKey,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            verticalSpaceMedium,
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                "${AppRes.participants}: ${model.members.length}",
                                style: AppTextStyle(
                                  color: ColorRes.dimGray,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            verticalSpaceTiny,
                          /*  GridView.builder(
                              itemCount: categoryDataList.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return UserCard(
                                  user: categoryDataList[index],
                                );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                              ),
                            ),*/
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              model.doneClick();
            },
            child: Icon(
              Icons.done,
              color: ColorRes.white,
            ),
            backgroundColor: ColorRes.green,
          ),
        );
      },
    );
  }
  Future<void> getContactList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLogin = true;
    });
    var url = Uri.https('www.harisangam.com', '/index.php/api/user/test/users');


    Response response = await post(
      url,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    print("CategoryList::$responseBody");
    if (statusCode == 200) {
      setState(() {
        isLogin = false;
        categoryList = CategoryList.fromJson(jsonDecode(responseBody));
        categoryDataList.addAll(categoryList.data);
      });
    }
  }
}
