import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:XLINXCHAT/style/theme.dart';

import '../../Colors.dart';
import 'SuccessMorseCodeScreen.dart';

class MorseCodeScreen extends StatefulWidget {
  @override
  _MorseCodeScreenState createState() => _MorseCodeScreenState();
}

class _MorseCodeScreenState extends State<MorseCodeScreen> {
  String otp = '';

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
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
                top: size.height * 0.085, bottom: size.height * 0.045),
            alignment: Alignment.center,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "输入邮箱一次性验证码",
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: size.height * 0.024,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: size.height * 0.12,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OTPTextField(
                        length: 4,
                        width: MediaQuery.of(context).size.width,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldWidth: 45,
                        fieldStyle: FieldStyle.box,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Mulish',
                        ),
                        onChanged: (pin) {
                          print("Changed: " + pin);
                        },
                        onCompleted: (pin) {
                          setState(() {
                            otp = pin;
                          });
                          print("Completed: " + pin);
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.07,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.36,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SuccessMorseCodeScreen()),
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
                        children: [Text("继续", style: CustomTheme.whiteLargeTitle)],
                      ),
                    ),
                  ),
                ]),
          ),
        ));
  }
}
