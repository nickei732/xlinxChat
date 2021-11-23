import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:XLINXCHAT/model/message_model.dart';
import 'package:XLINXCHAT/screen/person/chat_screen/widget/message_view/document_message.dart';
import 'package:XLINXCHAT/screen/person/chat_screen/widget/message_view/image_message.dart';
import 'package:XLINXCHAT/screen/person/chat_screen/widget/message_view/text_message.dart';
import 'package:XLINXCHAT/utils/app_state.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageView extends StatelessWidget {
  final int index;
  final MessageModel message;
  final Function(String, String) downloadDocument;
  final Function(MessageModel, bool) onLongPress;
  final Function(MessageModel) onTapPress;
  final List<MessageModel> selectedMessages;
  final bool forwardMode;
  final bool deleteMode;
  SharedPreferences prefs;
  MessageView(
    this.index,
    this.message,
    this.downloadDocument,
    this.selectedMessages,
    this.onTapPress,
    this.onLongPress,
    this.deleteMode,
    this.forwardMode, this.prefs,
  );

  @override
  Widget build(BuildContext context) {
    final bool contains = selectedMessages
        .where((element) => element.id == message.id)
        .isNotEmpty;
    final bool sender = message.sender == prefs.getString("UserId");
    return GestureDetector(
      onLongPress: forwardMode || deleteMode
          ? null
          : () {
              onLongPress.call(message, sender);
            },
      onTap: () {
        if (forwardMode) {
          onTapPress.call(message);
        } else if (deleteMode) {
          if (sender) {
            onTapPress.call(message);
          }
        }
      },
      child: Stack(
        alignment: sender ? Alignment.centerRight : Alignment.centerLeft,
        children: [
          message.type == "text"
              ? TextMessage(message, sender)
              : message.type == "photo"
                  ? ImageMessage(message, forwardMode || deleteMode, sender)
                  : DocumentMessage(
                      message,
                      downloadDocument,
                      sender,
                      forwardMode || deleteMode,
                    ),
          contains
              ? Positioned.fill(
                  child: Container(
                    width: Get.width,
                    constraints: BoxConstraints(
                      minHeight: 30,
                    ),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: sender
                          ? BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12))
                          : BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12)),
                      color: ColorRes.green.withOpacity(0.3),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
