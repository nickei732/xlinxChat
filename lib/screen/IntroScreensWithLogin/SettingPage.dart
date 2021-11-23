import 'package:flutter/material.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/styles.dart';


class SettingPage extends StatefulWidget{

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "没有通话记录:)",
          style: AppTextStyle(
            color: ColorRes.black,
            weight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
