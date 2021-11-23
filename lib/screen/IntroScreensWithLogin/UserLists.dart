import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:XLINXCHAT/provider/ColorsInf.dart';
import 'package:XLINXCHAT/provider/DarkThemeProvider.dart';
import 'package:XLINXCHAT/screen/home/home_screen.dart';
import 'package:XLINXCHAT/screen/home/home_view_model.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import '../../Colors.dart';
import '../../model/ContactList.dart';

class UserLists extends StatefulWidget {
  @override
  _UserListsState createState() => _UserListsState();
}

class _UserListsState extends State<UserLists> {
  bool isLogin = false;
  CategoryList categoryList;
  CategoryData user = CategoryData();
  List<CategoryData> categoryDataList = [];
  DarkThemeProvider themeChange;
  ColorsInf colorsInf;
  String searchKey = '';
  final TextEditingController _nameController = TextEditingController();
  var queryResultSet = [];
  var tempSearchStore = [];

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
    getContactList();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    themeChange = Provider.of<DarkThemeProvider>(context);
    colorsInf = getColor(context);
    return ViewModelBuilder<HomeViewModel>.reactive(
      onModelReady: (model) async {
        model.init();
      },
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorRes.background,
            elevation: 0,
            title: Text(
              "与朋友私聊",
              style: AppTextStyle(
                color: ColorRes.black,
                weight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                onSelected: (String value) {
                  if (value == "create_group") {
                    model.createGroupClick();
                  } else {
                    print("value::$value");
                    model.personalChatClick();
                  }
                },
                child: SvgPicture.asset(
                  "assets/icons/addIcon.svg",
                  height: 30.0,
                  width: 30.0,
                  color: primaryColor,
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'create_group',
                    child: Text("创建组"),
                  ),
                  const PopupMenuItem<String>(
                    value: 'create_user',
                    child: Text("创建个人聊天"),
                  ),
                  /*  const PopupMenuItem<String>(
                    value: 'create_broadcast',
                    child: Text(AppRes.create_broadcast),
                  ),*/
                ],
              ),
              IconButton(
                onPressed: () {
                  model.gotoSettingPage(colorsInf);
                },
                icon: Icon(
                  Icons.settings,
                  color: ColorRes.black,
                ),
              ),
            ],
          ),
          body: !isLogin
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                                hintText: "${"搜索"}...",
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
                      Container(
                        child: ListView.builder(
                            itemCount: categoryDataList.length,
                            shrinkWrap: true, // use
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return categoryDataList[index]
                                          .customerEmail
                                          .startsWith(
                                              searchKey.toLowerCase()) ||
                                      categoryDataList[index]
                                          .customerEmail
                                          .startsWith(searchKey)
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {});
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              top: size.height * 0.004,
                                              left: size.width * 0.05,
                                              right: size.width * 0.001,
                                              bottom: size.height * 0.001),
                                          width: size.width * 0.28,
                                          height: size.height * 0.1,
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 40.0,
                                                width: 40.0,
                                                child: Image.asset(
                                                  "assets/images/uicons.png",
                                                  height: size.height * 0.01,
                                                  width: size.height * 0.01,
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.035,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: size.width * 0.6,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          categoryDataList[
                                                                  index]
                                                              .customerEmail,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Mulish',
                                                            fontSize:
                                                                size.width *
                                                                    0.045,
                                                            color: primaryColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: size.width * 0.02,
                                                  ),
                                                  Container(
                                                    width: size.width * 0.6,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          categoryDataList[
                                                                  index]
                                                              .customerFname,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Mulish',
                                                            fontSize:
                                                                size.width *
                                                                    0.03,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                descriptionColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    )
                                  : Container();
                            }),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                  color: buttonTextColor,
                )),
        );
      },
    );
  }

  Future<void> getContactList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLogin = true;
    });
    var url = Uri.https('www.harisangam.com', '/index.php/api/user/users');

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
