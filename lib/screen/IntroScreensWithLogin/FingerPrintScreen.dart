import 'package:flutter/material.dart';

import 'package:local_auth/local_auth.dart';
import '../../Colors.dart';
import 'FingerPrintSuccessPage.dart';
import 'MorseCodeScreen.dart';
import '../../Utils/Authantication.dart';

class FingerPrintScreen extends StatefulWidget {

  @override
  _FingerPrintScreenState createState() => _FingerPrintScreenState();
}

class _FingerPrintScreenState extends State<FingerPrintScreen> {
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
        /*  title: Text(
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
          margin: EdgeInsets.only(top: size.height*0.04),
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
              height: size.height * 0.085,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '开始采集指纹信息……',
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: size.height * 0.022,
                      color: blueshColor,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '点按屏幕',
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: size.height * 0.022,
                      color: blueshColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                bool isAuthenticated =
                    await Authentication.authenticateWithBiometrics();

                if (isAuthenticated) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FingerPrintSuccessPage(),
                    ),
                  );
                } else {
                 print("Error authenticating using Biometrics.");
                }              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/finderPrint.png',
                    height: size.height * 0.35,
                    width: size.width * 0.35,
                  ),
                ],
              ),
            ),



          ]),
        ));
  }


}
