import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
abstract class CustomTheme {
  static const Color primaryColor = const Color(0xFF0D5D84);
  static const Color primaryColorDark = const Color(0xFF112955);
  static const Color screenTitleColor = const Color(0xff0C233C);
  static const Color white = const Color(0xffffffff);
  static const Color grey = const Color(0xff97AAC3);
  static const Color lightColor = const Color(0xff8BD8EF);
  static const Color redColor = const Color(0xffFF0000);
  static const Color redColorDark = const Color(0xffc62121);
  static const Color bottomNavBGColor = const Color(0xffFCFCFF);
  static const Color bottomNavTextColor = const Color(0xff97AAC3);
  static const Color overlayDark =const Color(0x208F94FB);
  static const Color iconColor =const Color(0xffADB5BD);

  static const String iosMeetingAppBarRGBAColor = "#908F94FB"; //transparent blue

  static const primaryGradient = const LinearGradient(
    colors: const [primaryColor, primaryColorDark],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static TextStyle screenTitle = TextStyle(
    fontFamily: 'Mulish',
    color: screenTitleColor,
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static TextStyle btnTitle = TextStyle(
    fontFamily: 'Mulish',
    color: white,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  static TextStyle whiteTitle = TextStyle(
    fontFamily: 'Mulish',
    color: white,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
  static TextStyle whiteLargeTitle = TextStyle(
    fontFamily: 'Mulish',
    color: white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static TextStyle blackTitle = TextStyle(
    fontFamily: 'Mulish',
    color: Colors.black,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
  static TextStyle textFieldTitle = TextStyle(
    fontFamily: 'Mulish',
    color: primaryColor,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  static TextStyle textFieldTitlePrimaryColored = TextStyle(
    fontFamily: 'Mulish',
    color: primaryColorDark,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  static TextStyle smallTextStyle = TextStyle(
    fontFamily: 'Mulish',
    color: grey,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
  static TextStyle smallTextStyleRegular = TextStyle(
    fontFamily: 'Mulish',
    color: grey,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );
  static TextStyle smallTextStyleColored = TextStyle(
    fontFamily: 'Mulish',
    color: primaryColor,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
  static TextStyle smallTextStyleColoredUnderLine = TextStyle(
    fontFamily: 'Mulish',
    color: primaryColor,
    fontSize: 12,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
  );

  static TextStyle displayTextOne = TextStyle(
    fontFamily: 'Mulish',
    color: grey,
    fontSize: 18,
    fontStyle:FontStyle.normal,
    fontWeight: FontWeight.normal,
  );
  static TextStyle alartTextStyle = TextStyle(
    fontFamily: 'Mulish',
    color: redColor,
    fontSize: 18,
    fontStyle:FontStyle.normal,
    fontWeight: FontWeight.normal,
  );
  static TextStyle subTitleText = TextStyle(
    fontFamily: 'Mulish',
    color: grey,
    fontSize: 14,
    fontStyle:FontStyle.normal,
    fontWeight: FontWeight.normal,
  );
  static TextStyle subTitleTextColored = TextStyle(
    fontFamily: 'Mulish',
    color: primaryColor,
    fontSize: 14,
    fontStyle:FontStyle.normal,
    fontWeight: FontWeight.normal,
  );
  static TextStyle displayTextColoured = TextStyle(
    fontFamily: 'Mulish',
    color: primaryColor,
    fontSize: 18,
    fontStyle:FontStyle.normal,
    fontWeight: FontWeight.normal,
  );
  static TextStyle displayTextBoldColoured = TextStyle(
    fontFamily: 'Mulish',
    color: primaryColor,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static TextStyle displayTextBoldColouredSmall = TextStyle(
    fontFamily: 'Mulish',
    color: primaryColor,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static TextStyle displayTextBoldPrimaryColor = TextStyle(
    fontFamily: 'Mulish',
    color: primaryColorDark,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static TextStyle displayTextBoldBlackColor = TextStyle(
    fontFamily: 'Mulish',
    color: Color(0xff646464),
    fontSize: 16,
  );
  static TextStyle displayErrorText = TextStyle(
    fontFamily: 'Mulish',
    color: redColor,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  //card boxShadow
  static List<BoxShadow> boxShadow = [
    BoxShadow(
      color: overlayDark,
      offset: Offset(0.0, 3.0),
      blurRadius: 7.0,
    ),
  ];
  //icon boxShadow
  static List<BoxShadow> iconBoxShadow = [
    BoxShadow(
      color:overlayDark,
      offset: Offset(1, 6.0),
      blurRadius: 15.0,
    ),
    BoxShadow(
      color: overlayDark,
      offset: Offset(1, 6.0),
      blurRadius: 15.0,
    ),
  ];
  //icon boxShadow
  static List<BoxShadow> navBoxShadow = [BoxShadow(blurRadius: 10,color: Color(0xFF0D5D84),offset: Offset(1,5))];
  //card Shadow
}
