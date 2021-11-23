import 'dart:io';
import 'dart:io' as io;
import 'dart:math';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:file/local.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:XLINXCHAT/model/message_model.dart';
import 'package:XLINXCHAT/model/room_model.dart';
import 'package:XLINXCHAT/model/send_notification_model.dart';
import 'package:XLINXCHAT/screen/forward/forward.dart';
import 'package:XLINXCHAT/screen/home/home_screen.dart';
import 'package:XLINXCHAT/screen/person/chat_screen/chat_screen.dart';
import 'package:XLINXCHAT/screen/person/chat_screen/widget/message_dialog_view.dart';
import 'package:XLINXCHAT/screen/person/person_details/person_details.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/app_state.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class ChatScreenViewModel extends BaseViewModel {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  LocalFileSystem localFileSystem = LocalFileSystem();

  RoomModel receiver;
  bool isFromHome;
  bool isAttachment = false;
  bool isTyping = false;
  bool isMicTap = false;

  Recording _recording = new Recording();
  bool _isRecording = false;
  TextEditingController _controller = new TextEditingController();
  String roomId;
  int chatLimit = 20;
  MMessage message;
  bool _isPaused = false;
  int _recordDuration = 0;
  final ScrollController listScrollController = ScrollController();

  List<DocumentSnapshot> listMessage = [];

  final ImagePicker picker = ImagePicker();
  bool uploadingMedia = false;

  List<MessageModel> selectedMessages = [];
  bool isSelectionMode = false;
  bool showScrollDownBtn = false;
  bool isDeleteMode = false;
  bool isForwardMode = false;
  bool isReply = false;

  DocumentSnapshot roomDocument;

  void init(RoomModel receiver, bool isFromHome, String roomId) async {
    setBusy(true);
    appState.currentActiveRoom = roomId;
    this.isFromHome = isFromHome;
    this.receiver = receiver;
    this.roomId = roomId;
    listScrollController.addListener(manageScrollDownBtn);
    setBusy(false);
  }

  void onScrollDownTap() {
    listScrollController.position.jumpTo(0);
  }

  void manageScrollDownBtn() {
    if (listScrollController.position.pixels > 150) {
      if (!showScrollDownBtn) {
        showScrollDownBtn = true;
        notifyListeners();
      }
    } else {
      if (showScrollDownBtn) {
        showScrollDownBtn = false;
        notifyListeners();
      }
    }
  }

  void onBack() {
    appState.currentActiveRoom = null;
    updateTyping(false);
    if (isFromHome)
      Get.back();
    else
      Get.offAll(() => HomeScreen());
  }

  Future<void> headerClick() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    updateTyping(false);
    focusNode.unfocus();
    Get.to(() => PersonDetails(receiver, roomId, prefs));
  }

  void onTextFieldChange() {
    if (appLifeState != AppLifecycleState.paused) {
      if (controller.text.isEmpty) {
        isTyping = false;
        updateTyping(false);
        notifyListeners();
      } else {
        updateTyping(true);
        if (!isTyping) {
          isTyping = true;
          notifyListeners();
        }
      }
    }
  }

  updateTyping(bool data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    chatRoomService.updateLastMessage(
      {"${prefs.getString("UserId")}_typing": data},
      roomId,
    );
  }

  void unBlockTap() {
    Get.back();
    chatRoomService.updateLastMessage({
      "blockBy": null,
    }, roomId);
  }

  void onSend(MMessage message) async {
    if (controller.text
        .trim()
        .isNotEmpty) {
      sendMessage("text", controller.text.trim(), message);
      controller.clear();
      isTyping = false;
      updateTyping(false);
      notifyListeners();
    } else {
      Get.snackbar(
        "Alert",
        "Please! type message",
        duration: Duration(seconds: 5),
        backgroundColor: ColorRes.red,
        colorText: ColorRes.white,
        icon: Icon(
          Icons.cancel,
          color: ColorRes.white,
          size: 32,
        ),
      );
    }
  }

  void sendMessage(String type, String content, MMessage message) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = '';
    if (receiver.createdBy == prefs.getString("UserId")) {
      id = receiver.membersId[1];
    } else {
      id = receiver.membersId[0];
    }
    print("--------RoomID------------$roomId");
    DateTime messageTime = DateTime.now();
    if (roomId == null) {
      String chatId = '';
      if (id.hashCode <= prefs
          .getString("UserId")
          .hashCode) {
        chatId = '${id.toString()}-${prefs.getString("UserId")}';
      } else {
        chatId = '${prefs.getString("UserId")}-${id.toString()}';
      }
      roomId = chatId;
      await chatRoomService.createChatRoom({
        "isGroup": false,
        "id": chatId,
        "membersId": [prefs.getString("UserId"), id.toString()],
        "lastMessage": "Tap here",
        "${prefs.getString("UserId")}_typing": false,
        "${id.toString()}_typing": false,
        "${prefs.getString("UserId")}_newMessage": 0,
        "${id.toString()}_newMessage": 0,
        "newMessage": 0,
        "lastMessageTime": messageTime,
        "fcmToken": await FirebaseMessaging.instance.getToken(),
        "blockBy": null,
      });
      roomDocument = await chatRoomService.getParticularRoom(roomId);
    }

    MessageModel messageModel = MessageModel(
      content: content,
      sender: prefs.getString("UserId"),
      sendTime: messageTime.millisecondsSinceEpoch,
      type: type,
      receiver: id.toString(),
      mMessage: message,
    );

    String notificationBody;
    switch (type) {
      case "text":
        notificationBody = content;
        break;
      case "photo":
        notificationBody = "📷 Image";
        break;
      case "document":
        notificationBody = "📄 Document";
        break;
      case "music":
        notificationBody = "🎵 Music";
        break;
      case "Recording":
        notificationBody = "🎵 Recording";
        break;
      case "video":
        notificationBody = "🎥 Video";
        break;
      case "alert":
        notificationBody = content;
        break;
    }
// todo
    SendNotificationModel notificationModel = SendNotificationModel(
      isGroup: false,
      title: prefs.getString("Username"),
      body: notificationBody,
      fcmToken: await FirebaseMessaging.instance.getToken(),
      roomId: roomId,
      id: prefs.getString("UserId"),
    );

    chatRoomService.sendMessage(messageModel, roomId);
    int newMessage = roomDocument.get("${id.toString()}_newMessage");
    newMessage++;
    chatRoomService.updateLastMessage(
      {
        "lastMessage": notificationBody,
        "lastMessageTime": messageTime,
        "${id.toString()}_newMessage": newMessage
      },
      roomId,
    );

    // ignore: unnecessary_statements
    "nsdfmsndmfnsmfnsfnsdfnfksf" != await FirebaseMessaging.instance.getToken()
        ? messagingService.sendNotification(notificationModel)
        : null;
    // ignore: invalid_use_of_protected_member
    if (listScrollController.positions.isNotEmpty) {
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void clearNewMessage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    chatRoomService.updateLastMessage(
      {"${prefs.getString("UserId")}_newMessage": 0},
      roomId,
    );
  }

  void onCameraTap() async {
    isAttachment = false;
    notifyListeners();
    focusNode.unfocus();
    final imagePath = await picker.getImage(source: ImageSource.camera);
    if (imagePath != null) {
      uploadingMedia = true;
      notifyListeners();
      String imageUrl =
      await storageService.uploadImage(File(imagePath.path), roomId);
      if (imageUrl != null) {
        sendMessage("photo", imageUrl, null);
      }
      uploadingMedia = false;
      notifyListeners();
    }
  }

  void onMicTap() async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var release = int.parse(androidInfo.version.release);
    Permission permission;
    if (release < 11) {
      await Permission.microphone.request();
      await Permission.storage.request();
      if (await Permission.microphone
          .request()
          .isGranted &&
          await Permission.storage
              .request()
              .isGranted) {
        Random random = new Random();
        int randomNumber = random.nextInt(100);
        try {
          if (await AudioRecorder.hasPermissions) {
            if (_controller.text != null && _controller.text != "") {
              String path = _controller.text;
              if (!_controller.text.contains('/')) {
                io.Directory appDocDirectory =
                await getApplicationDocumentsDirectory();
                path = appDocDirectory.path + '/' + randomNumber.toString();
              }
              print("Start recording: $path");
              await AudioRecorder.start(
                  path: path, audioOutputFormat: AudioOutputFormat.AAC);
            } else {
              await AudioRecorder.start();
            }
            bool isRecording = await AudioRecorder.isRecording;
            _recording = new Recording(duration: new Duration(), path: "");
            _isRecording = isRecording;
          } else {
            print("You must accept permissions");
          }
        } catch (e) {
          print(e);
        }
      }
    } else {
      Permission.manageExternalStorage.request();
      await Permission.microphone.request();
      if (await Permission.microphone
          .request()
          .isGranted &&
          await Permission.manageExternalStorage
              .request()
              .isGranted) {
        Random random = new Random();
        int randomNumber = random.nextInt(100);
        try {
          if (await AudioRecorder.hasPermissions) {
            if (_controller.text != null && _controller.text != "") {
              String path = _controller.text;
              if (!_controller.text.contains('/')) {
                io.Directory appDocDirectory =
                await getApplicationDocumentsDirectory();
                path = appDocDirectory.path + '/' + randomNumber.toString();
              }
              print("Start recording: $path");
              await AudioRecorder.start(
                  path: path, audioOutputFormat: AudioOutputFormat.AAC);
            } else {
              await AudioRecorder.start();
            }
            bool isRecording = await AudioRecorder.isRecording;
            _recording = new Recording(duration: new Duration(), path: "");
            _isRecording = isRecording;
          } else {
            print("You must accept permissions");
          }
        } catch (e) {
          print(e);
        }
      } else {
        return null;
      }
    }
  }

  void conferenceTap()
  {

  }

  void onStop() async {
    var recording = await AudioRecorder.stop();
    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    File file = localFileSystem.file(recording.path);
    print("  File length: ${await file.length()}");
    _recording = recording;
    _isRecording = isRecording;
    _controller.text = recording.path;
    uploadingMedia = true;
    notifyListeners();
    String imageUrl = await storageService.uploadMusic(File(file.path), roomId);
    if (imageUrl != null) {
      sendMessage("Recording", imageUrl, null);
      String filePath = await getUploadPath("recordVoice", "Recording");
      await File(filePath).create(recursive: true);
      await File(filePath).writeAsBytes(await File(file.path).readAsBytes());
      uploadingMedia = false;
      notifyListeners();
    }
  }

  void onGalleryTap() async {
    isAttachment = false;
    notifyListeners();
    final imagePath = await picker.getImage(source: ImageSource.gallery);
    if (imagePath != null) {
      uploadingMedia = true;
      notifyListeners();
      String imageUrl =
          await storageService.uploadImage(File(imagePath.path), roomId);
      if (imageUrl != null) {
        sendMessage("photo", imageUrl, null);
      }
      uploadingMedia = false;
      notifyListeners();
    }
  }

  void onDocumentTap() async {
    isAttachment = false;
    notifyListeners();
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: [
        'pdf',
        'xlsx',
        'xlsm',
        'xls',
        'ppt',
        'pptx',
        'doc',
        'docx',
        'txt',
        'text',
        'rtf',
        'zip',
      ],
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.size > 67108864) {
        showErrorToast("Can not upload more than 64MB");
      } else {
        print(file.path);
        uploadingMedia = true;
        notifyListeners();
        String imageUrl =
            await storageService.uploadDocument(File(file.path), roomId);
        if (imageUrl != null) {
          sendMessage("document", imageUrl, null);
          String filePath = await getUploadPath(file.name, "document");
          await File(filePath).create(recursive: true);
          await File(filePath)
              .writeAsBytes(await File(file.path).readAsBytes());
        }
        uploadingMedia = false;
        notifyListeners();
      }
    }
  }

  void onVideoTap() async {
    isAttachment = false;
    notifyListeners();
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.size > 67108864) {
        showErrorToast("Can not upload more than 64MB");
      } else {
        uploadingMedia = true;
        notifyListeners();
        String imageUrl =
            await storageService.uploadVideo(File(file.path), roomId);
        if (imageUrl != null) {
          sendMessage("video", imageUrl, null);
          String filePath = await getUploadPath(file.name, "video");
          await File(filePath).create(recursive: true);
          await File(filePath)
              .writeAsBytes(await File(file.path).readAsBytes());
        }
        uploadingMedia = false;
        notifyListeners();
      }
    }
  }

  void onAudioTap() async {
    isAttachment = false;
    notifyListeners();
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.size > 67108864) {
        showErrorToast("Can not upload more than 64MB");
      } else {
        uploadingMedia = true;
        notifyListeners();
        String imageUrl =
            await storageService.uploadMusic(File(file.path), roomId);
        if (imageUrl != null) {
          sendMessage("music", imageUrl, null);
          String filePath = await getUploadPath(file.name, "music");
          await File(filePath).create(recursive: true);
          await File(filePath)
              .writeAsBytes(await File(file.path).readAsBytes());
        }
        uploadingMedia = false;
        notifyListeners();
      }
    }
  }

  void onAttachmentTap() {
    focusNode.unfocus();
    isAttachment = !isAttachment;
    notifyListeners();
  }

  void downloadDocument(String url, String filePath) async {
    await File(filePath).create(recursive: true);
    await storageService.downloadMedia(url, filePath);
  }

  void enableForwardSelectionMode(MessageModel messageModel) {
    if (!isForwardMode) {
      isForwardMode = true;
      selectedMessages.add(messageModel);
      notifyListeners();
    }
  }

  void enableDeleteSelectionMode(MessageModel messageModel) {
    if (!isDeleteMode) {
      isDeleteMode = true;
      selectedMessages.add(messageModel);
      notifyListeners();
    }
  }

  void clearReply() {
    isReply = false;
    message = null;
    notifyListeners();
  }

  void onLongPressMessage(MessageModel messageModel, bool sender) async {
    bool isDeletePossible = false;
    print(
        "sendtime::${DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(messageModel.sendTime))}");
    print(DateFormat('yyyy-MM-dd hh:mm:ss').format(
        DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch)));
    final f = new DateFormat('yyyy-MM-dd hh:mm:ss');
    String one1 = f
        .format(new DateTime.fromMillisecondsSinceEpoch(messageModel.sendTime));
    print("one1::$one1");
    String two1 = f.format(DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch));
    final format = DateFormat("yyyy-MM-dd hh:mm:ss");
    var one = format.parse(one1);
    var two = format.parse(two1);
    print("${two.difference(one).inDays}");
    var oneDiff = format.parse("2021-09-12 00:00:00");
    var twoDiff = format.parse("2021-09-12 00:00:60");

    print("diiff::  " + "${twoDiff.difference(oneDiff).inDays}");

    if (two.difference(one).inDays >= twoDiff.difference(oneDiff).inDays &&
        two.difference(one).inSeconds >=
            twoDiff.difference(oneDiff).inSeconds) {
      print("Not Applicable for Delete");
      isDeletePossible = false;
    } else {
      print("Applicable for Delete");
      isDeletePossible = true;
    }
    focusNode.unfocus();
    Get.dialog(Dialog(
      child: MessageDialog(
        sender: sender,
        message: messageModel,
        value: isDeletePossible,
        onDeleteTap: () {
          chatRoomService.deleteMessage(messageModel.id, roomId);
          Get.back();
        },
        onReplyTap: () {
          isReply = true;
          message = MMessage(
            mContent: messageModel.content,
            mDataType: messageModel.type,
            mType: Type.reply,
          );
          Get.back();
          notifyListeners();
        },
        onForwardTap: () {
          Get.back();
          Get.to(() => Forward([messageModel]));
        },
        onDeleteMultipleTap: () {
          enableDeleteSelectionMode(messageModel);
          Get.back();
        },
        onForwardMultipleTap: () {
          enableForwardSelectionMode(messageModel);
          Get.back();
        },
      ),
    ));
  }

  void onTapPressMessage(MessageModel messageModel) async {
    if (isDeleteMode) {
      if (selectedMessages
          .where((element) => element.id == messageModel.id)
          .isNotEmpty) {
        selectedMessages
            .removeWhere((element) => element.id == messageModel.id);
        if (selectedMessages.isEmpty) {
          isDeleteMode = false;
        }
      } else {
        selectedMessages.add(messageModel);
      }
      notifyListeners();
    } else if (isForwardMode) {
      if (selectedMessages
          .where((element) => element.id == messageModel.id)
          .isNotEmpty) {
        selectedMessages
            .removeWhere((element) => element.id == messageModel.id);
        if (selectedMessages.isEmpty) {
          isDeleteMode = false;
        }
      } else {
        selectedMessages.add(messageModel);
      }
      notifyListeners();
    }
  }

  void deleteClickMessages() async {
    showConfirmationDialog(
      () async {
        print("Confirmation");
        Get.back();
        for (var value in selectedMessages) {
          chatRoomService.deleteMessage(value.id, roomId);
        }
        selectedMessages.clear();
        isDeleteMode = false;
        notifyListeners();
      },
      "Are you sure you want to delete messages?",
    );
  }

  void clearClick() {
    isForwardMode = false;
    isDeleteMode = false;
    selectedMessages.clear();
    notifyListeners();
  }

  void forwardClickMessages() async {
    final data = await Get.to(() => Forward(selectedMessages));
    if (data != null) {
      clearClick();
    }
  }
}
