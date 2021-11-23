import 'package:flutter/material.dart';
import 'package:XLINXCHAT/style/theme.dart';
import '../../Colors.dart';
import 'FingerPrintScreen.dart';


class SuccessMorseCodeScreen extends StatefulWidget {

  @override
  _SuccessMorseCodeScreenState createState() => _SuccessMorseCodeScreenState();
}

class _SuccessMorseCodeScreenState extends State<SuccessMorseCodeScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController xLinxController = new TextEditingController();

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
          title: Text(
            "[不明确的]",
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: size.height * 0.024,
                color: blueshColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/success.png',
                  height: size.height * 0.35,
                  width: size.width * 0.35,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '密码验证成功',
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: size.height * 0.022,
                      color: blueshColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.32,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FingerPrintScreen()),
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
          ]),
        ));
  }
}
