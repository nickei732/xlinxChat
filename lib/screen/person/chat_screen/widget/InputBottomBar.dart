import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:XLINXCHAT/Colors.dart';
import 'package:XLINXCHAT/model/message_model.dart';
import 'package:XLINXCHAT/provider/ColorsInf.dart';
import 'package:XLINXCHAT/screen/person/chat_screen/widget/reply_message.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/styles.dart';

class InputBottomBar extends StatefulWidget {
  InputBottomBar({
    this.msgController,
    this.onTextFieldChange,
    this.onCameraTap,
    this.onSend,
    this.focusNode,
    this.onAttachment,
    this.isTyping,
    this.message,
    this.onMicTap,
    this.onMicStop,
    this.clearReply,
    this.colorsInf,
    this.onVideoTap
  });

  final TextEditingController msgController;
  final VoidCallback onTextFieldChange;
  final VoidCallback onCameraTap;
  final VoidCallback onAttachment;
  final VoidCallback onVideoTap;
  final VoidCallback onMicTap;
  final VoidCallback onMicStop;
  final Function(MMessage) onSend;
  final FocusNode focusNode;
  final bool isTyping;
  final MMessage message;
  final Function clearReply;
  final ColorsInf colorsInf;
  @override
  _InputBottomBarState createState() => _InputBottomBarState();
}

class _InputBottomBarState extends State<InputBottomBar>
    with SingleTickerProviderStateMixin {
  bool onMicTap = false;
  bool onMicStop = false;
  Animation<Color> animation;
  AnimationController controller;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.linear);
    animation =
        ColorTween(begin: Colors.white, end: Colors.blue).animate(curve);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
      setState(() {});
    });
    controller.forward();
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: widget.message == null
          ? Container(
              padding: EdgeInsets.only(
                left: 5,
              ),
              margin: EdgeInsets.only(left: 5, bottom: 5, right: 5),
              child: Row(
                children: [
                 Container(
                    padding: EdgeInsets.only(left: 13, right: 5),
                    child: InkWell(
                      onTap: () {
                        widget.onAttachment.call();
                      },
                      child: Icon(
                        Icons.add,
                        size: 20,
                        color: ColorRes.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 5),
                      padding: EdgeInsets.only(left: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              style: AppTextStyle(color: ColorRes.black),
                              maxLines: 5,
                              focusNode: widget.focusNode,
                              textCapitalization: TextCapitalization.sentences,
                              minLines: 1,
                              onChanged: (_) {
                                widget.onTextFieldChange();
                              },
                              controller: widget.msgController,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                hintText: widget.colorsInf.typeMessegeText,
                                hintStyle: AppTextStyle(
                                  fontSize: 15,
                                  color: ColorRes.black,
                                ),
                                labelStyle:AppTextStyle(
                                  fontSize: 15,
                                  color: ColorRes.black,
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 10.h, bottom: 5.h),
                              ),
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.only(left: 13, right: 5),
                            child: InkWell(
                              onTap: () {
                                widget.onVideoTap.call();
                              },
                              child: Icon(
                                Icons.video_call,
                                size: 28,
                                color: locationTextColor,
                              ),
                            ),
                          ),
                           !onMicTap
                                  ? Container(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 11),
                                      child: InkWell(
                                        onTap: () {
                                          checkPermissionStatus();
                                        },
                                        child: Icon(
                                          Icons.mic,
                                          color: ColorRes.black,
                                        ),
                                      ),
                                    )
                                  : Container(),
                          widget.isTyping
                              ? Container()
                              : onMicTap
                                  ? Container(
                                      padding: EdgeInsets.only(
                                          left: 5,
                                          right: 11,
                                          top: !onMicTap ? 0 : 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          AnimatedBuilder(
                                            animation: animation,
                                            builder: (BuildContext context,
                                                Widget child) {
                                              return new Container(
                                                color: Colors.red,
                                                width: 14.0,
                                                height: 16.0,
                                                child: new RaisedButton(
                                                  color: animation.value,
                                                  focusColor: Colors.red,
                                                  onPressed: () {
                                                    controller.forward();
                                                    widget.onMicStop.call();
                                                    setState(() {
                                                      onMicStop = true;
                                                      onMicTap = false;
                                                    });
                                                  },
                                                  child: Text(
                                                    "停止",
                                                    style: TextStyle(
                                                        fontSize: 8.0),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          Text(
                                            "停止",
                                            style: TextStyle(
                                                fontSize: 8.0,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onSend.call(widget.message);
                    },
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 13, right: 11),
                      decoration: BoxDecoration(
                        color: ColorRes.green,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.send,
                        color: ColorRes.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              padding: EdgeInsets.only(
                left: 5,
              ),
              margin: EdgeInsets.only(left: 5, bottom: 5, right: 5),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            widget.message.mDataType == "photo" ? 7 : 16,
                        vertical: 6),
                    margin: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorRes.green,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        color: ColorRes.green.withOpacity(0.1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReplyMessage(widget.message),
                        InkWell(
                          onTap: () {
                            widget.clearReply.call();
                          },
                          child: Icon(
                            Icons.close_rounded,
                            color: ColorRes.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 5),
                          padding: EdgeInsets.only(left: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: ColorRes.green,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  style: AppTextStyle(color: ColorRes.white),
                                  maxLines: 5,
                                  focusNode: widget.focusNode,
                                  textCapitalization: TextCapitalization.sentences,
                                  minLines: 1,
                                  onChanged: (_) {
                                    widget.onTextFieldChange();
                                  },
                                  controller: widget.msgController,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                    hintText: "输入消息..",
                                    counterText: '',
                                    hintStyle: AppTextStyle(
                                      fontSize: 15,
                                      color: ColorRes.black,
                                    ),
                                    labelStyle:AppTextStyle(
                                      fontSize: 15,
                                      color: ColorRes.black,
                                    ),
                                    contentPadding:
                                    EdgeInsets.only(left: 10.h, bottom: 5.h),
                                  ),
                                ),
                              ),
                              widget.isTyping
                                  ? Container()
                                  : Container(
                                      padding:
                                          EdgeInsets.only(left: 13, right: 5),
                                      child: RotationTransition(
                                        turns:
                                            AlwaysStoppedAnimation(135 / 360),
                                        child: InkWell(
                                          onTap: () {
                                            if (widget.message != null)
                                              widget.clearReply.call();
                                            else
                                              widget.onAttachment.call();
                                          },
                                          child: Icon(
                                            Icons.attachment,
                                            size: 28,
                                            color: ColorRes.white,
                                          ),
                                        ),
                                      ),
                                    ),
                              widget.isTyping
                                  ? Container()
                                  : Container(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 11),
                                      child: InkWell(
                                        onTap: () {
                                          if (widget.message != null)
                                            widget.clearReply.call();
                                          else
                                            widget.onCameraTap.call();
                                        },
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: ColorRes.white,
                                        ),
                                      ),
                                    ),
                              widget.isTyping
                                  ? Container()
                                  : !onMicTap
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              left: 5, right: 11),
                                          child: InkWell(
                                            onTap: () {
                                              checkPermissionStatus();
                                            },
                                            child: Icon(
                                              Icons.mic,
                                              color: ColorRes.white,
                                            ),
                                          ),
                                        )
                                      : Container(),
                              widget.isTyping
                                  ? Container()
                                  : onMicTap
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              left: 5,
                                              right: 11,
                                              top: !onMicTap ? 0 : 8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              AnimatedBuilder(
                                                animation: animation,
                                                builder: (BuildContext context,
                                                    Widget child) {
                                                  return new Container(
                                                    color: Colors.red,
                                                    width: 14.0,
                                                    height: 16.0,
                                                    child: new RaisedButton(
                                                      color: animation.value,
                                                      focusColor: Colors.red,
                                                      onPressed: () {
                                                        controller.forward();
                                                        widget.onMicStop.call();
                                                        setState(() {
                                                          onMicStop = true;
                                                          onMicTap = false;
                                                        });
                                                      },
                                                      child: Text(
                                                        "停止",
                                                        style: TextStyle(
                                                            fontSize: 8.0),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              Text(
                                                "停止",
                                                style: TextStyle(
                                                    fontSize: 8.0,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (widget.msgController.text.trim().isNotEmpty) {
                            widget.clearReply.call();
                            widget.onSend.call(widget.message);
                          }
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.only(left: 13, right: 11),
                          decoration: BoxDecoration(
                            color: ColorRes.green,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.send,
                            color: ColorRes.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  void checkPermissionStatus() async {
    widget.onMicTap.call();
    if (await Permission.microphone.request().isGranted &&
        await Permission.storage.request().isGranted) {
      setState(() {
        onMicTap = true;
      });
    }
  }
}
