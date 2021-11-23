import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:XLINXCHAT/service/auth_service/auth_service.dart';
import 'package:XLINXCHAT/service/chat_room_service/chat_room_service.dart';
import 'package:XLINXCHAT/service/group_service/group_service.dart';
import 'package:XLINXCHAT/service/messaging/messaging_service.dart';
import 'package:XLINXCHAT/service/storage_service/storage_service.dart';
import 'package:XLINXCHAT/service/user_service/user_service.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/exception.dart';
import 'package:XLINXCHAT/utils/styles.dart';

class AppRes {
  /// Define all static strings here
  /// example app name, tab title, form title, strings, etc.

  static const String appName = "XLINX-CHAT";

  static const String sign_in = "Sign In";
  static const String sign_up = "Sign Up";
  static const String forgot_password = "Forgot Password?";
  static const String submit = "Submit";
  static const String newGroup = "新组";
  static const String newBroadcast = "新的广播";
  static const String select_person_or_group = "选择个人或群组";
  static const String new_personal_chat = "新的个人聊天";
  static const String add_participants = "添加参与者";
  static const String select_person = "选择人员";
  static const String participants = "参与者";
  static const String add_description = "添加说明";
  static const String type_group_title_here = "在此处输入群组标题...";
  static const String type_your_name_here = "于此处输入您的姓名...";
  static const String type_group_description_here =
      "在此处键入组描述...";
  static const String provide_group_description_and_icon =
      "提供组描述和图标（可选";

  static const String email = "Email";
  static const String password = "Password";
  static const String full_name = "Full Name";

  static const String welcome = "Welcome";
  static const String no_user_found = "No user found :(";
  static const String no_user_or_group_found = "没有找到用户或组:(";

  static const String sign_in_successfully = "Sign in successfully";
  static const String sign_up_successfully = "Sign up successfully";

  static const String send_email_successfully =
      "Password reset link has been sent to your email successfully";

  /// validation strings
  static const String can_not_be_empty = "Can not be empty";
  static const String select_at_least_one_member = "选择至少一名成员";
  static const String select_at_least_one_person = "至少选择一个人";
  static const String please_enter_full_name = "Please enter full name";
  static const String please_enter_valid_full_name =
      "Please enter valid full name";
  static const String please_enter_email = "Please enter email";
  static const String please_enter_valid_email = "Please enter valid email";
  static const String please_enter_password = "Please enter password";
  static const String please_enter_min_6_characters =
      "Please enter min 6 characters";

  static const String type_a_message = "输入消息...";

  static const String icons = 'assets/icons/';
  static const String images = 'assets/images/';

  static const String create_group = "Create Group";
  static const String create_personal_chat = "Create Personal Chat";
  static const String create_broadcast = "New Broadcast";

  static const String document = "Document";
  static const String video = "Video";
  static const String gallery = "Gallery";
  static const String audio = "Audio";

  static const String block = "堵塞";
    static const String make_admin = "让管理员";
  static const String remove_admin = "删除管理员";
  static const String remove_from_group = "从组中删除";
  static const String delete_group = "删除群组";
  static const String info = "信息";
  static const String left_group = "离开团队";
  static const String send_message = "发信息";
  static const String done = "完毕";

  static const String delete = "删除";
  static const String reply = "回复";
  static const String forward = "向前";
  static const String forwardMultiple = "转发多个";
  static const String deleteMultiple = "全部删除";
}

class AssetsRes {
  static String whatsAppIcon = AppRes.icons + "whatsapp_icon" + ".jpeg";
  static String profileImage = AppRes.images + "profile" + ".png";
  static String groupImage = AppRes.images + "group_image" + ".png";
}

showErrorToast(String message, {String title}) {
  Get.snackbar(title ?? "Error", message,
      backgroundColor: ColorRes.red, colorText: ColorRes.white);
}

showSuccessToast(String message, {String title}) {
  Get.snackbar(title ?? "Successful", message,
      backgroundColor: ColorRes.green, colorText: ColorRes.white);
}

// Horizontal Spacing
Widget horizontalSpaceTiny = SizedBox(width: 5.h);
Widget horizontalSpaceSmall = SizedBox(width: 10.h);
Widget horizontalSpaceRegular = SizedBox(width: 15.h);
Widget horizontalSpaceMedium = SizedBox(width: 20.h);
Widget horizontalSpaceLarge = SizedBox(width: 30.h);
Widget horizontalSpaceMassive = SizedBox(width: 50.h);

// Vertical Spacing
Widget verticalSpaceTiny = SizedBox(height: 5.h);
Widget verticalSpaceSmall = SizedBox(height: 10.h);
Widget verticalSpaceRegular = SizedBox(height: 15.h);
Widget verticalSpaceMedium = SizedBox(height: 20.h);
Widget verticalSpaceLarge = SizedBox(height: 30.h);
Widget verticalSpaceMassive = SizedBox(height: 50.h);

AuthService authService = AuthService();
UserService userService = UserService();
MessagingService messagingService = MessagingService();
GroupService groupService = GroupService();
StorageService storageService = StorageService();
ChatRoomService chatRoomService = ChatRoomService();

bool isEmail(String email) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(p);
  return regExp.hasMatch(email);
}

String hFormat(DateTime date) {
  if (DateTime.now().difference(date).inDays == 1) {
    return "yesterday";
  } else if (DateTime.now().difference(date).inDays > 364) {
    return DateFormat('dd-MM-yyyy').format(date);
  } else if (DateTime.now().difference(date).inDays > 1) {
    return DateFormat('dd-MM').format(date);
  } else {
    return DateFormat('hh:mm a').format(date);
  }
}

String convertSize(int size) {
  String newSize = "";
  int kbSize = size ~/ 1024;
  if (kbSize > 1024) {
    newSize = "${(size ~/ 1024) ~/ 1024} mb";
  } else {
    newSize = "${size ~/ 1024} kb";
  }
  return newSize;
}

Future<bool> checkForExist(String name, String type) async {
  String appFolder =
      Platform.isIOS ? "/media/$type/" : "xlinx/media/$type/";
  Directory directory;
  if (Platform.isIOS) {
    directory = await getApplicationDocumentsDirectory();
  } else {
    directory = Directory("/storage/emulated/0/");
  }

  String filePath = "${directory.path}$appFolder$name";
  try {
    final data = await File(filePath).exists();
    return data;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> checkForSenderExist(String name, String type) async {
  String appFolder =
      Platform.isIOS ? "/media/$type/sent/" : "xlinx/media/$type/sent/";
  Directory directory;
  if (Platform.isIOS) {
    directory = await getApplicationDocumentsDirectory();
  } else {
    directory = Directory("/storage/emulated/0/");
  }

  String filePath = "${directory.path}$appFolder$name";
  try {
    final data = await File(filePath).exists();
    return data;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<String> getDownloadPath(String name, String type) async {
  Directory directory;
  if (Platform.isIOS) {
    directory = await getApplicationDocumentsDirectory();

    try {
      var status = await Permission.storage.request();
      if (status.isGranted) {
          if (!await Directory(directory.path + "/media").exists()) {
          await Directory(directory.path + "/media").create();
          if (!await Directory(directory.path + "/media/$type").exists()) {
            await Directory(directory.path + "/media/$type").create();
          }
        } else if (!await Directory(directory.path + "/media/$type").exists()) {
          await Directory(directory.path + "/media/$type").create();
        }

        directory = Directory(directory.path + "/media/$type");

        String filePath = "${directory.path}/$name";
        return filePath;
      } else {
        return null;
      }
    } catch (e) {
      handleException(e);
      return null;
    }
  } else {
    directory = Directory("/storage/emulated/0/");

    try {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        if (!await Directory(directory.path + "xlinx").exists()) {
          await Directory(directory.path + "xlinx").create();
          if (!await Directory(directory.path + "xlinx/media").exists()) {
            await Directory(directory.path + "xlinx/media").create();
            if (!await Directory(directory.path + "xlinx/media/$type")
                .exists()) {
              await Directory(directory.path + "xlinx/media/$type")
                  .create();
            }
          } else if (!await Directory(directory.path + "xlinx/media/$type")
              .exists()) {
            await Directory(directory.path + "xlinx/media/$type").create();
          }
        } else if (!await Directory(directory.path + "xlinx/media")
            .exists()) {
          await Directory(directory.path + "xlinx/media").create();
          if (!await Directory(directory.path + "xlinx/media/$type")
              .exists()) {
            await Directory(directory.path + "xlinx/media/$type").create();
          }
        } else if (!await Directory(directory.path + "xlinx/media/$type")
            .exists()) {
          await Directory(directory.path + "xlinx/media/$type").create();
        }

        directory = Directory(directory.path + "xlinx/media/$type");

        String filePath = "${directory.path}/$name";
        return filePath;
      } else {
        return null;
      }
    } catch (e) {
      handleException(e);
      return null;
    }
  }
}

Future<String> getPlayDownlaodPath(String name, String type) async {
  Directory directory;
  if (Platform.isIOS) {
    directory = await getApplicationDocumentsDirectory();

    try {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        if (!await Directory(directory.path + "/media").exists()) {
          await Directory(directory.path + "/media").create();
          if (!await Directory(directory.path + "/media/$type").exists()) {
            await Directory(directory.path + "/media/$type").create();
          }
        } else if (!await Directory(directory.path + "/media/$type").exists()) {
          await Directory(directory.path + "/media/$type").create();
        }

        directory = Directory(directory.path + "/media/$type");

        String filePath = "${directory.path}/$name";
        return filePath;
      } else {
        return null;
      }
    } catch (e) {
      handleException(e);
      return null;
    }
  } else {
    directory = Directory("/storage/emulated/0/");

    try {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        if (!await Directory(directory.path + "xlinx").exists()) {
          await Directory(directory.path + "xlinx").create();
          if (!await Directory(directory.path + "xlinx/media").exists()) {
            await Directory(directory.path + "xlinx/media").create();
            if (!await Directory(directory.path + "xlinx/media/$type")
                .exists()) {
              await Directory(directory.path + "xlinx/media/$type")
                  .create();
            }
          } else if (!await Directory(directory.path + "xlinx/media/$type")
              .exists()) {
            await Directory(directory.path + "xlinx/media/$type").create();
          }
        } else if (!await Directory(directory.path + "xlinx/media")
            .exists()) {
          await Directory(directory.path + "xlinx/media").create();
          if (!await Directory(directory.path + "xlinx/media/$type")
              .exists()) {
            await Directory(directory.path + "xlinx/media/$type").create();
          }
        } else if (!await Directory(directory.path + "xlinx/media/$type")
            .exists()) {
          await Directory(directory.path + "xlinx/media/$type").create();
        }

        directory = Directory(directory.path + "xlinx/media/$type");

        String filePath = "${directory.path}/$name";
        return filePath;
      } else {
        return null;
      }
    } catch (e) {
      handleException(e);
      return null;
    }
  }
}

Future<String> getUploadPath(String name, String type) async {

  Directory directory;
  if (Platform.isIOS) {
    directory = await getApplicationDocumentsDirectory();

    try {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        if (!await Directory(directory.path + "/media").exists()) {
          await Directory(directory.path + "/media").create();
          if (!await Directory(directory.path + "/media/$type").exists()) {
            await Directory(directory.path + "/media/$type").create();
          }
        } else if (!await Directory(directory.path + "/media/$type").exists()) {
          await Directory(directory.path + "/media/$type").create();
        }

        if (!await Directory(directory.path + "/media/$type/sent").exists()) {
          await Directory(directory.path + "/media/$type/sent").create();
        }

        directory = Directory(directory.path + "/media/$type/sent");

        String filePath = "${directory.path}/$name";

        return filePath;
      } else {
        return null;
      }
    } catch (e) {
      handleException(e);
      return null;
    }
  } else {
    directory = Directory("/storage/emulated/0/");
    try {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = int.parse(androidInfo.version.release);
      Permission permission;
      if (release < 11) {
         Permission.storage.request();
         if (await Permission.storage.request().isGranted) {
           if (!await Directory(directory.path + "xlinx").exists()) {
             await Directory(directory.path + "xlinx").create();
             if (!await Directory(directory.path + "xlinx/media").exists()) {
               await Directory(directory.path + "xlinx/media").create();
               if (!await Directory(directory.path + "xlinx/media/$type")
                   .exists()) {
                 await Directory(directory.path + "xlinx/media/$type")
                     .create();
               }
             } else if (!await Directory(directory.path + "xlinx/media/$type")
                 .exists()) {
               await Directory(directory.path + "xlinx/media/$type").create();
             }
           } else if (!await Directory(directory.path + "xlinx/media")
               .exists()) {
             await Directory(directory.path + "xlinx/media").create();
             if (!await Directory(directory.path + "xlinx/media/$type")
                 .exists()) {
               await Directory(directory.path + "xlinx/media/$type").create();
             }
           } else if (!await Directory(directory.path + "xlinx/media/$type")
               .exists()) {
             await Directory(directory.path + "xlinx/media/$type").create();
           }

           if (!await Directory(directory.path + "xlinx/media/$type/sent")
               .exists()) {
             await Directory(directory.path + "xlinx/media/$type/sent")
                 .create();
           }

           directory = Directory(directory.path + "xlinx/media/$type/sent");

           String filePath = "${directory.path}/$name";
           return filePath;
         } else {
           return null;
         }
      } else {
        Permission.manageExternalStorage.request();
        if (await Permission.manageExternalStorage.isGranted) {
          if (!await Directory(directory.path + "xlinx").exists()) {
            await Directory(directory.path + "xlinx").create();
            if (!await Directory(directory.path + "xlinx/media").exists()) {
              await Directory(directory.path + "xlinx/media").create();
              if (!await Directory(directory.path + "xlinx/media/$type")
                  .exists()) {
                await Directory(directory.path + "xlinx/media/$type")
                    .create();
              }
            } else if (!await Directory(directory.path + "xlinx/media/$type")
                .exists()) {
              await Directory(directory.path + "xlinx/media/$type").create();
            }
          } else if (!await Directory(directory.path + "xlinx/media")
              .exists()) {
            await Directory(directory.path + "xlinx/media").create();
            if (!await Directory(directory.path + "xlinx/media/$type")
                .exists()) {
              await Directory(directory.path + "xlinx/media/$type").create();
            }
          } else if (!await Directory(directory.path + "xlinx/media/$type")
              .exists()) {
            await Directory(directory.path + "xlinx/media/$type").create();
          }

          if (!await Directory(directory.path + "xlinx/media/$type/sent")
              .exists()) {
            await Directory(directory.path + "xlinx/media/$type/sent")
                .create();
          }

          directory = Directory(directory.path + "xlinx/media/$type/sent");

          String filePath = "${directory.path}/$name";
          return filePath;
        } else {
          return null;
        }
      }

    } catch (e) {
      handleException(e);
      return null;
    }
  }
}

showConfirmationDialog(Function call, String title) {
  return Get.dialog(
    Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          verticalSpaceSmall,
          Text(
            "Confirmation",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          verticalSpaceSmall,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(title),
          ),
          verticalSpaceMedium,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: ColorRes.dimGray,
                  child: Text(
                    "Cancel",
                    style: AppTextStyle(
                      color: ColorRes.white,
                    ),
                  ),
                ),
              ),
              horizontalSpaceSmall,
              InkWell(
                onTap: call,
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: ColorRes.green,
                  child: Text(
                    "Confirm",
                    style: AppTextStyle(
                      color: ColorRes.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          verticalSpaceSmall,
        ],
      ),
    ),
  );
}
