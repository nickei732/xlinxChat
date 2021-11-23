import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:XLINXCHAT/screen/login/sign_in_screen.dart';
import 'package:XLINXCHAT/style/theme.dart';
import '../../Colors.dart';
import 'MorseCodeScreen.dart';
import '../../Presentation/BottomNavigationBar.dart';

class FingerPrintSuccessPage extends StatefulWidget {
  const FingerPrintSuccessPage({Key key}) : super(key: key);

  @override
  _FingerPrintSuccessPageState createState() => _FingerPrintSuccessPageState();
}

class _FingerPrintSuccessPageState extends State<FingerPrintSuccessPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController xLinxController = new TextEditingController();
  final LocalAuthentication localAuthentication = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
              color: Colors.black,
              size: size.height * 0.05 //change your color here
              ),
          titleSpacing: 0,
         /* title: Text(
            "[不明确的]",
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: size.height * 0.024,
                color: blueshColor,
                fontWeight: FontWeight.bold),
          ),*/
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: EdgeInsets.only(top: size.height * 0.04),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '将手指放在\n按指纹',
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: size.height * 0.025,
                      color: blueshColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.055,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '指纹信息采集成功！\n请移开手指',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: size.height * 0.022,
                      color: blueshColor,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/colorfinger.png',
                    height: size.height * 0.35,
                    width: size.width * 0.35,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '建议设置多个指纹\n为避免意外情况导致无法解锁或转移',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: size.height * 0.022,
                      color: blueshColor,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.055,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => bottomNavigationBarT2("abc")),
                );
              },
              child: Container(
                height: size.height * 0.065,
                margin: EdgeInsets.only(
                    left: size.width * 0.045, right: size.width * 0.045),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xff0D9FCC), Color(0xff15255D)],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("继续 ", style: CustomTheme.whiteLargeTitle)],
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.015,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '不用谢，继续下一步',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: size.height * 0.022,
                      color: blueshColor,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ]),
        ));
  }
}
