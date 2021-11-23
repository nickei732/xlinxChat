import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:XLINXCHAT/model/message_model.dart';
import 'package:XLINXCHAT/model/room_model.dart';
import 'package:XLINXCHAT/provider/ColorsInf.dart';
import 'package:XLINXCHAT/provider/DarkThemeProvider.dart';
import 'package:XLINXCHAT/screen/home/home_screen.dart';
import 'package:XLINXCHAT/screen/person/chat_screen/chat_screen_view_model.dart';
import 'package:XLINXCHAT/screen/person/chat_screen/widget/InputBottomBar.dart';
import 'package:XLINXCHAT/screen/person/chat_screen/widget/header.dart';
import 'package:XLINXCHAT/screen/person/chat_screen/widget/message_view/message_view.dart';
import 'package:XLINXCHAT/screen/person/chat_screen/widget/scroll_down_button.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/common_widgets.dart';
import 'package:XLINXCHAT/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

AppLifecycleState appLifeState;

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  final RoomModel receiver;
  final bool isFromHome;
  String roomId;
  SharedPreferences prefs;

  ChatScreen(
    this.receiver,
    this.isFromHome,
    this.roomId,
    this.prefs,
  );

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  SharedPreferences prefs;
  bool isInitialized = false;
  DarkThemeProvider themeChange;
  ColorsInf colorsInf;

  @override
  void initState() {
    super.initState();
    print("done");
    getPreference();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appLifeState = state;
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      print(widget.roomId);
      if (widget.roomId != null) {
        chatRoomService.updateLastMessage(
          {"${prefs.getString("UserId")}_typing": false},
          widget.roomId,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    themeChange = Provider.of<DarkThemeProvider>(context);
    colorsInf = getColor(context);
    return ViewModelBuilder<ChatScreenViewModel>.reactive(
      onModelReady: (model) async {
        model.init(widget.receiver, widget.isFromHome, widget.roomId);
      },
      builder: (context, model, child) {
        widget.roomId = model.roomId;
        return WillPopScope(
          onWillPop: () async {
            if (model.isForwardMode || model.isDeleteMode) {
              model.clearClick();
            } else {
              model.onBack();
            }
            return false;
          },
          child: GestureDetector(
            onTap: () {
              if (model.isAttachment) {
                model.isAttachment = false;
                model.notifyListeners();
              }
            },
            child: Scaffold(
              backgroundColor: ColorRes.background,
              appBar: isInitialized
                  ? PreferredSize(
                      preferredSize: Size(Get.width, 50),
                      child: model.roomId == null
                          ? Header(
                              userModel: widget.receiver,
                              onBack: model.onBack,
                              headerClick: model.headerClick,
                              isDeleteMode: model.isDeleteMode,
                              isForwardMode: model.isForwardMode,
                              deleteClick: model.deleteClickMessages,
                              forwardClick: model.forwardClickMessages,
                              clearClick: model.clearClick,
                              prefs: prefs)
                          : StreamBuilder<DocumentSnapshot>(
                              stream: chatRoomService
                                  .streamParticularRoom(model.roomId),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  model.roomDocument = snapshot.data;
                                  model.clearNewMessage();
                                  return Header(
                                      userModel: widget.receiver,
                                      onBack: model.onBack,
                                      headerClick: model.headerClick,
                                      isDeleteMode: model.isDeleteMode,
                                      isForwardMode: model.isForwardMode,
                                      deleteClick: model.deleteClickMessages,
                                      forwardClick: model.forwardClickMessages,
                                      clearClick: model.clearClick,
                                      typing: false,
                                      prefs: prefs);
                                } else {
                                  return Header(
                                      userModel: widget.receiver,
                                      onBack: model.onBack,
                                      headerClick: model.headerClick,
                                      isDeleteMode: model.isDeleteMode,
                                      isForwardMode: model.isForwardMode,
                                      deleteClick: model.deleteClickMessages,
                                      forwardClick: model.forwardClickMessages,
                                      clearClick: model.clearClick,
                                      prefs: prefs);
                                }
                              },
                            ),
                    )
                  : null,
              body: model.roomId == null
                  ? model.isBusy
                      ? Center(
                          child: Platform.isIOS
                              ? CupertinoActivityIndicator()
                              : CircularProgressIndicator(),
                        )
                      : Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            AbsorbPointer(
                              absorbing: model.isAttachment,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text("Send a message"),
                                    ),
                                  ),
                                  InputBottomBar(
                                    msgController: model.controller,
                                    onTextFieldChange: model.onTextFieldChange,
                                    onCameraTap: model.onCameraTap,
                                    onSend: model.onSend,
                                    message: model.message,
                                    onMicTap: model.onMicTap,
                                    onMicStop: model.onStop,
                                    onVideoTap: model.conferenceTap,
                                    focusNode: model.focusNode,
                                    onAttachment: model.onAttachmentTap,
                                    isTyping: false,
                                    clearReply: model.clearReply,
                                    colorsInf: colorsInf,
                                  ),
                                ],
                              ),
                            ),
                            SafeArea(
                              child: AnimatedOpacity(
                                opacity: model.isAttachment ? 1 : 0,
                                duration: Duration(milliseconds: 500),
                                child: model.isAttachment
                                    ? AttachmentView(
                                        onGalleryTap: model.onGalleryTap,
                                        onAudioTap: model.onAudioTap,
                                        onVideoTap: model.onVideoTap,
                                        onDocumentTap: model.onDocumentTap,
                                        colorsInf: colorsInf,
                                      )
                                    : Container(),
                              ),
                            ),
                            model.uploadingMedia
                                ? Container(
                                    height: Get.height,
                                    width: Get.width,
                                    color: ColorRes.dimGray.withOpacity(0.3),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Platform.isIOS
                                            ? CupertinoActivityIndicator()
                                            : CircularProgressIndicator(),
                                        verticalSpaceSmall,
                                        Text("Uploading media")
                                      ],
                                    ),
                                  )
                                : Container()
                          ],
                        )
                  : Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        AbsorbPointer(
                          absorbing: model.isAttachment,
                          child: Column(
                            children: [
                              Expanded(
                                child: PaginateFirestore(
                                  padding: EdgeInsets.all(10.0),
                                  query: chatRoomService.getMessages(
                                      model.roomId, model.chatLimit),
                                  itemBuilderType: PaginateBuilderType.listView,
                                  isLive: true,
                                  itemsPerPage: 10,
                                  scrollController: model.listScrollController,
                                  itemBuilder:
                                      (index, context, documentSnapshot) {
                                    if (!model.listMessage
                                        .contains(documentSnapshot)) {
                                      model.listMessage.add(documentSnapshot);
                                    }
                                    return MessageView(
                                        index,
                                        MessageModel.fromMap(
                                          documentSnapshot.data(),
                                          documentSnapshot.id,
                                        ),
                                        model.downloadDocument,
                                        model.selectedMessages,
                                        model.onTapPressMessage,
                                        model.onLongPressMessage,
                                        model.isDeleteMode,
                                        model.isForwardMode,
                                        prefs);
                                  },
                                  emptyDisplay: Center(
                                    child: Text("发信息"),
                                  ),
                                  reverse: true,
                                ),
                              ),
                              StreamBuilder<DocumentSnapshot>(
                                stream: chatRoomService
                                    .streamParticularRoom(model.roomId),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return snapshot.data.get("blockBy") == null
                                        ? InputBottomBar(
                                            msgController: model.controller,
                                            onTextFieldChange:
                                                model.onTextFieldChange,
                                            onCameraTap: model.onCameraTap,
                                            onSend: model.onSend,
                                            onMicTap: model.onMicTap,
                                            onMicStop: model.onStop,
                                            message: model.message,
                                            focusNode: model.focusNode,
                                            onVideoTap: model.conferenceTap,
                                            onAttachment: model.onAttachmentTap,
                                            isTyping: model.isTyping,
                                            clearReply: model.clearReply,
                                            colorsInf: colorsInf,
                                          )
                                        : snapshot.data.get("blockBy") ==
                                                prefs.getString("UserId")
                                            ? InkWell(
                                                onTap: () {
                                                  showConfirmationDialog(
                                                    model.unBlockTap,
                                                    "Are you sure you want to unblock this use?",
                                                  );
                                                },
                                                child: Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: ColorRes.white,
                                                    border: Border.all(
                                                        color: ColorRes.red),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  width: Get.width,
                                                  margin: EdgeInsets.only(
                                                    left: 5,
                                                    bottom: 5,
                                                    right: 5,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      horizontalSpaceSmall,
                                                      Icon(
                                                        Icons.block,
                                                        color: ColorRes.red,
                                                        size: 22,
                                                      ),
                                                      horizontalSpaceMedium,
                                                      Text(
                                                        "解除封锁",
                                                        style: AppTextStyle(
                                                          fontSize: 18,
                                                          color: ColorRes.red,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: ColorRes.white,
                                                  border: Border.all(
                                                      color: ColorRes.red),
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                width: Get.width,
                                                margin: EdgeInsets.only(
                                                  left: 5,
                                                  bottom: 5,
                                                  right: 5,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    horizontalSpaceSmall,
                                                    Icon(
                                                      Icons.block,
                                                      color: ColorRes.red,
                                                      size: 22,
                                                    ),
                                                    horizontalSpaceMedium,
                                                    Text(
                                                      "你被屏蔽了",
                                                      style: AppTextStyle(
                                                        fontSize: 18,
                                                        color: ColorRes.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SafeArea(
                          child: AnimatedOpacity(
                            opacity: model.isAttachment ? 1 : 0,
                            duration: Duration(milliseconds: 500),
                            child: model.isAttachment
                                ? AttachmentView(
                                    onGalleryTap: model.onGalleryTap,
                                    onAudioTap: model.onAudioTap,
                                    onVideoTap: model.onVideoTap,
                                    onDocumentTap: model.onDocumentTap,
                                    colorsInf: colorsInf,
                                  )
                                : Container(),
                          ),
                        ),
                        model.showScrollDownBtn
                            ? Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 60),
                                  child: ScrollDownButton(
                                    onTap: model.onScrollDownTap,
                                  ),
                                ),
                              )
                            : Container(),
                        model.uploadingMedia
                            ? Container(
                                height: Get.height,
                                width: Get.width,
                                color: ColorRes.dimGray.withOpacity(0.3),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Platform.isIOS
                                        ? CupertinoActivityIndicator()
                                        : CircularProgressIndicator(),
                                    verticalSpaceSmall,
                                    Text("上传媒体")
                                  ],
                                ),
                              )
                            : Container()
                      ],
                    ),
            ),
          ),
        );
      },
      viewModelBuilder: () => ChatScreenViewModel(),
    );
  }

  Future<void> getPreference() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isInitialized = true;
    });
  }
}
