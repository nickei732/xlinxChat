import 'package:flutter/material.dart';
import 'package:XLINXCHAT/screen/IntroScreensWithLogin/SettingPage.dart';
import 'package:XLINXCHAT/screen/home/home_screen.dart';

import '../screen/IntroScreensWithLogin/CallLogs.dart';
import '../Colors.dart';
import '../screen/IntroScreensWithLogin/UserLists.dart';

class bottomNavigationBarT2 extends StatefulWidget {
  String s;
  bottomNavigationBarT2([this.s]);

  @override
  _bottomNavigationBarT2State createState() => _bottomNavigationBarT2State();
}

class _bottomNavigationBarT2State extends State<bottomNavigationBarT2> {
  int currentIndex = 0;

  /// Set a type current number a layout class
  Widget callPage(int current) {
    switch (current) {
      case 0:
        return new UserLists();
      case 1:
        return new CallLogs();
      case 2:
        return new HomeScreen(widget.s);
      case 3:
        return new HomeScreen(widget.s);
      case 4:
        return new SettingPage();
      default:
        return new UserLists();
    }
  }
@override
  void initState() {
    if(widget.s=="Personal" || widget.s=="group" )
      {
        currentIndex=2;
      }
    else
      {
        currentIndex=0;
      }
    // TODO: implement initState
    super.initState();
  }
  /// Build BottomNavigationBar Widget
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
      body: callPage(currentIndex),
      bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              textTheme: Theme.of(context).textTheme.copyWith(
                  caption: TextStyle(color: Colors.black26.withOpacity(0.15)))),
          child: SizedBox(
            height: size.height * 0.085,
            child: BottomNavigationBar(
              backgroundColor: whiteTextColor,
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              fixedColor: buttonTextColor,
              onTap: (value) {
                currentIndex = value;
                setState(() {});
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.supervised_user_circle_sharp,
                      color:
                          currentIndex == 0 ? buttonTextColor : primaryColor,
                      size: 30,
                    ),
                    title: Text(
                      "",
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          color: currentIndex == 2
                              ? buttonTextColor
                              : primaryColor,
                          fontSize: size.height * 0.015,
                          fontWeight: FontWeight.normal),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.phone,
                      color:
                          currentIndex == 1 ? locationTextColor : primaryColor,
                      size: 30,
                    ),
                    title: Text(
                      "",
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          color: currentIndex == 2
                              ? buttonTextColor
                              : whiteTextColor,
                          fontSize: size.height * 0.015,
                          fontWeight: FontWeight.normal),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.chat_bubble,
                      color:
                          currentIndex == 2 ? buttonTextColor : primaryColor,
                      size: 30,
                    ),
                    title: Text(
                      "",
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          color: currentIndex == 2
                              ? buttonTextColor
                              : whiteTextColor,
                          fontSize: size.height * 0.015,
                          fontWeight: FontWeight.normal),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.group,
                      color:
                          currentIndex == 3 ? buttonTextColor : primaryColor,
                      size: 30,
                    ),
                    // ignore: deprecated_member_use
                    title: Text(
                      "",
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          color: currentIndex == 2
                              ? buttonTextColor
                              : whiteTextColor,
                          fontSize: size.height * 0.015,
                          fontWeight: FontWeight.normal),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                      color:
                          currentIndex == 4 ? buttonTextColor : primaryColor,
                      size: 30,
                    ),
                    // ignore: deprecated_member_use
                    title: Text(
                      "",
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          color: currentIndex == 2
                              ? buttonTextColor
                              : whiteTextColor,
                          fontSize: size.height * 0.015,
                          fontWeight: FontWeight.normal),
                    )),
              ],
            ),
          )),
    );
  }
}
