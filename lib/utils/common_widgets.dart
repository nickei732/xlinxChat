import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:XLINXCHAT/provider/ColorsInf.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/styles.dart';

class EvolveButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final double width;
  final double height;
  final ColorsInf language;

  EvolveButton(
      {@required this.title,
      @required this.onTap,
      this.width,
      this.height,
      this.language});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? Get.width / 2,
        height: height ?? 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: ColorRes.green,
        ),
        alignment: Alignment.center,
        child: Container(
          child: Text(
            title,
            style: AppTextStyle(weight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  bool obs;
  final bool readOnly;

    TextFieldWidget({
    @required this.controller,
    @required this.title,
    this.obs = false,
    @required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: TextFormField(
        style: TextStyle(
          fontSize: 14,
          color: ColorRes.black,
        ),
        readOnly: readOnly,
        obscureText: obs,
        controller: controller,
        keyboardType: title.toLowerCase() == "email"
            ? TextInputType.emailAddress
            : title.toLowerCase() == "password"
                ? TextInputType.visiblePassword
                : TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xffE5E5E5),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorRes.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: ColorRes.white,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorRes.white, width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintText: title,
          counterText: '',
          hintStyle: AppTextStyle(
            fontSize: 14,
            color: ColorRes.black,
          ),
          contentPadding: EdgeInsets.only(left: 10.h),
        ),
      ),
    );
  }
}

class AttachmentView extends StatelessWidget {
  final Function onDocumentTap;
  final Function onVideoTap;
  final Function onGalleryTap;
  final Function onAudioTap;
  ColorsInf colorsInf;

  AttachmentView(
      {@required this.onDocumentTap,
      @required this.onVideoTap,
      @required this.onGalleryTap,
      @required this.onAudioTap,
      @required this.colorsInf});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorRes.creamColor,
      height: 90.h,
      width: Get.width,
      margin: EdgeInsets.only(
        bottom: 60,
        left: 16,
        right: 16,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconTile(
            text: "文档",
            icon: Icons.insert_drive_file,
            onTap: onDocumentTap,
          ),
          iconTile(
            text: "视频",
            icon: Icons.videocam_rounded,
            onTap: onVideoTap,
          ),
          iconTile(
            text: "画廊",
            icon: Icons.image_rounded,
            onTap: onGalleryTap,
          ),
          iconTile(
            text: "声音的",
            icon: Icons.headset_mic_rounded,
            onTap: onAudioTap,
          ),
        ],
      ),
    );
  }

  Widget iconTile({
    IconData icon,
    String text,
    VoidCallback onTap,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: ColorRes.green,
            child: Icon(
              icon,
              color: ColorRes.white,
              size: 21.h,
            ),
          ),
        ),
        verticalSpaceTiny,
        Text(
          text,
          style: AppTextStyle(
            fontSize: 14.h,
            color: ColorRes.black,
          ),
        ),
      ],
    );
  }
}
