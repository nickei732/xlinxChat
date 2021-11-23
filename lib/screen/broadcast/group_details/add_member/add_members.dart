import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'package:XLINXCHAT/model/ContactList.dart';
import 'package:XLINXCHAT/model/group_model.dart';
import 'package:XLINXCHAT/screen/broadcast/group_details/add_member/add_members_view_model.dart';
import 'package:XLINXCHAT/screen/broadcast/group_details/add_member/widgets/user_card.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class AddMembers extends StatefulWidget {
  final GroupModel groupModel;

  AddMembers(this.groupModel);

  @override
  _AddMembersState createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  bool isLogin = false;
  String searchKey = '';
  CategoryList categoryList;
  List<CategoryData> categoryDataList = [];
  var queryResultSet = [];
  var tempSearchStore = [];
  final TextEditingController _nameController = TextEditingController();

  initiateSearch([value]) {
    setState(() {
      searchKey = value;
    });
    print("value::$value");
    if (value.length == 0) {
      setState(() {
        tempSearchStore = []; //comment this if you want to always show.
      });

      var capitalizedValue =
          value.substring(0, 1).toUpperCase() + value.substring(1);

      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['engName'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
    return value;
  }

  @override
  void initState() {
    // TODO: implement initState
    getContactList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ViewModelBuilder<AddMembersViewModel>.reactive(
      onModelReady: (model) async {
        model.init(widget.groupModel);
      },
      viewModelBuilder: () => AddMembersViewModel(),
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
                  AppRes.newBroadcast,
                  style: AppTextStyle(
                    color: ColorRes.dimGray,
                    weight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  AppRes.add_participants,
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
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: size.height * 0.004,
                            left: size.width * 0.001,
                            right: size.width * 0.001,
                            bottom: size.height * 0.001),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 16, left: 16, right: 16, bottom: 16),
                          child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ColorRes.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: ColorRes.white, width: 1.0),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                hintText: "搜索...",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade600),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey.shade600,
                                  size: 20,
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                contentPadding: EdgeInsets.all(8),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade100)),
                              ),
                              onChanged: (val) {
                                initiateSearch(val.toUpperCase());
                              }),
                        ),
                      ),
                      ListView.builder(
                        itemCount: categoryDataList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return categoryDataList[index].customerEmail.startsWith(searchKey.toLowerCase()) || categoryDataList[index].customerEmail.startsWith(searchKey)? UserCard(
                            user: categoryDataList[index],
                            onTap: model.selectUserClick,
                            isSelected:
                            model.isSelected(categoryDataList[index]),
                          ):Container();
                        },
                      ),
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: model.nextClick,
            child: Icon(
              Icons.navigate_next_rounded,
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
    print("CategoryListAddParti..::$responseBody");
    if (statusCode == 200) {
      setState(() {
        isLogin = false;
        categoryList = CategoryList.fromJson(jsonDecode(responseBody));
        categoryDataList.addAll(categoryList.data);
      });
    }
  }
}
