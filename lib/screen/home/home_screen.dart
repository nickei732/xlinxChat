import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:XLINXCHAT/model/group_model.dart';
import 'package:XLINXCHAT/model/room_model.dart';
import 'package:XLINXCHAT/provider/ColorsInf.dart';
import 'package:XLINXCHAT/provider/DarkThemeProvider.dart';
import 'package:XLINXCHAT/provider/EnglishLanguage.dart';
import 'package:XLINXCHAT/provider/ChineseLangauge.dart';
import 'package:XLINXCHAT/screen/home/home_view_model.dart';
import 'package:XLINXCHAT/screen/home/widgets/group_card.dart';
import 'package:XLINXCHAT/screen/home/widgets/user_card.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class HomeScreen extends StatefulWidget {
  String groupType;

  HomeScreen([this.groupType]);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchKey = '';
  Stream streamQuery;
  final TextEditingController _nameController = TextEditingController();
  var queryResultSet = [];
  var tempSearchStore = [];
  SharedPreferences prefs;
  bool isInitialized = false;
  DarkThemeProvider themeChange;
  ColorsInf colorsInf;

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
    super.initState();
    getPreference();
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
        return WillPopScope(
          onWillPop: () {
            showConfirmationDialog(
              () {
                SystemNavigator.pop();
              },
              'Are you sure you want to exit ?',
            );
            return null;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: ColorRes.background,
            appBar: AppBar(
              backgroundColor: ColorRes.background,
              elevation: 0,
              title: Text(
                "聊天室列表",
                style: AppTextStyle(
                  color: ColorRes.black,
                  weight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              actions: [
             /*   Container(
                  margin:EdgeInsets.only(top: size.height*0.01) ,
                  child: IconButton(
                    onPressed: () {
                      changeLanguage();
                    },
                    icon: Column(
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.language,
                              color: ColorRes.black,
                            ),
                            Text(
                              colorsInf.languageText,
                              style: AppTextStyle(
                                color: ColorRes.black,
                                weight: FontWeight.bold,
                                fontSize: 4,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),*/
                PopupMenuButton<String>(
                  onSelected: (String value) {
                    if (value == "create_group") {
                      model.createGroupClick();
                    } else if (value == "create_user") {
                      print("value::$value");
                      model.personalChatClick();
                    } else {
                      model.createBroadcastClick();
                    }
                  },
                  child: Icon(
                    Icons.add_circle_outline,
                    color: ColorRes.black,
                  ),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'create_group',
                      child: Text("创建组"),
                    ),
                    const PopupMenuItem<String>(
                      value: 'create_user',
                      child: Text("创建个人聊天"),
                    ),

                  ],
                ),
                IconButton(
                  onPressed: (){
                    model.gotoSettingPage(colorsInf);
                  },
                  icon: Icon(
                    Icons.more_vert_outlined,
                    color: ColorRes.black,
                  ),
                ),
              ],
            ),
            body: model.isBusy && !isInitialized
                ? Center(
                    child: Platform.isIOS
                        ? CupertinoActivityIndicator()
                        : CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
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
                        !isInitialized
                            ? Container()
                            : StreamBuilder<QuerySnapshot>(
                                stream: chatRoomService.streamRooms(prefs),
                                builder: (context, roomSnapshot) {
                                  if (roomSnapshot.hasData) {
                                    if (roomSnapshot.data.docs.isEmpty) {
                                      return Center(
                                        child:
                                            Text(""),
                                      );
                                    } else {
                                      return ListView.builder(
                                          shrinkWrap: true, // use
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              roomSnapshot.data.docs.length,

                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            RoomModel roomModel =
                                                RoomModel.fromMap(roomSnapshot
                                                    .data.docs[index]
                                                    .data());
                                            if (roomModel.isGroup) {
                                              return StreamBuilder<
                                                  DocumentSnapshot>(
                                                stream:
                                                    groupService.getGroupStream(
                                                        roomModel.id),
                                                builder: (context, groupSnap) {
                                                  if (groupSnap
                                                              .connectionState ==
                                                          ConnectionState
                                                              .active &&
                                                      groupSnap.hasData) {
                                                    roomModel.groupModel =
                                                        GroupModel.fromMap(
                                                            groupSnap.data
                                                                .data(),
                                                            groupSnap.data.id);
                                                    print(
                                                        "initialSearchGroup::${searchKey.toLowerCase()}");
                                                    print(
                                                        "UsercardDataGroup:::${roomModel.groupModel.name}");
                                                    print(
                                                        "UsercardDataFilterGroup:::${roomModel.groupModel.name.startsWith(searchKey.toLowerCase())}");

                                                    return roomModel.groupModel
                                                                    .createdBy ==
                                                                prefs.getString(
                                                                    "UserId") &&
                                                            roomModel.groupModel
                                                                    .description ==
                                                                "ConfirmBroadcast"
                                                        ? roomModel.groupModel.name.startsWith(searchKey.toLowerCase()) ||
                                                                roomModel
                                                                    .groupModel
                                                                    .name
                                                                    .startsWith(
                                                                        searchKey)
                                                            ? GroupCard(
                                                                roomModel,
                                                                widget
                                                                    .groupType,
                                                                widget.groupType ==
                                                                        "group"
                                                                    ? model
                                                                        .groupClick
                                                                    : model
                                                                        .broadcastClick,
                                                                newBadge: roomSnapshot
                                                                    .data
                                                                    .docs[index]
                                                                    .get(
                                                                        "${prefs.getString("UserId")}_newMessage"),
                                                              )
                                                            : Container()
                                                        : roomModel.groupModel
                                                                    .description !=
                                                                "ConfirmBroadcast"
                                                            ? roomModel.groupModel.name.startsWith(searchKey.toLowerCase()) ||
                                                                    roomModel
                                                                        .groupModel
                                                                        .name
                                                                        .startsWith(
                                                                            searchKey)
                                                                ? GroupCard(
                                                                    roomModel,
                                                                    widget
                                                                        .groupType,
                                                                    widget.groupType ==
                                                                            "group"
                                                                        ? model
                                                                            .groupClick
                                                                        : model
                                                                            .broadcastClick,
                                                                    newBadge: roomSnapshot
                                                                        .data
                                                                        .docs[
                                                                            index]
                                                                        .get(
                                                                            "${prefs.getString("UserId")}_newMessage"),
                                                                  )
                                                                : Container()
                                                            : Container();
                                                  } else {
                                                    return Container();
                                                  }
                                                },
                                              );
                                            } else {
                                              print("----roommodel----");
                                              print(
                                                  "UserId:::${prefs.getString("UserId")}");
                                              print(roomModel
                                                  .membersId[0].hashCode);
                                              /*  print(
                                                "initialSearch::${searchKey.toLowerCase()}");
                                            print(
                                                "UsercardData:::${roomModel.userModel.name}");
                                            print(
                                                "UsercardDataFilter:::${roomModel.userModel.name.startsWith(searchKey.toLowerCase())}");
*/
                                              return roomModel.membersName[1]
                                                          .startsWith(searchKey
                                                              .toLowerCase()) ||
                                                      roomModel.membersName[1]
                                                          .startsWith(searchKey)
                                                  ? UserCard(
                                                      index,
                                                      prefs,
                                                      roomModel,
                                                      model.onUserCardTap,
                                                      typing: false,
                                                      newBadge: roomSnapshot
                                                          .data.docs[index]
                                                          .get(
                                                              "${prefs.getString("UserId")}_newMessage"),
                                                    )
                                                  : Container(); // JX0105215
                                            }
                                          });
                                    }
                                  } else {
                                    return Center(
                                      child: Platform.isIOS
                                          ? CupertinoActivityIndicator()
                                          : CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  onSearchTextChanged(String text) async {
    print("Text::::$text");
    if (text.isEmpty) {
      setState(() {});
      return;
    }
  }

  Future<void> getPreference() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getString("selectLanguage") != null ||
        prefs.getString("selectLanguage") != "null") {
      setState(() {
        themeChange.selectLanguage = prefs.getString("selectLanguage");
      });
    } else {
      setState(() {
        themeChange.selectLanguage = "1";
      });
    }
    setState(() {
      isInitialized = true;
    });
  }

  Future<void> changeLanguage() async {
    if (themeChange.selectLanguage == "2") {
      themeChange.selectLanguage = "1";
    }
    else {
      themeChange.selectLanguage = "2";
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("selectLanguage", "1");
  }
}

ColorsInf getColor(BuildContext context) {
  DarkThemeProvider darkThemeProvider = Provider.of<DarkThemeProvider>(context);
  return LanguageEnglish();
}
