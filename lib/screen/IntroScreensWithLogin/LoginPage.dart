import 'dart:convert';

import 'package:XLINXCHAT/Colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:XLINXCHAT/Presentation/edit_text_utils.dart';
import 'package:XLINXCHAT/model/XlinxLoginResponse.dart';
import 'package:XLINXCHAT/screen/login/sign_in_screen.dart';
import 'package:XLINXCHAT/style/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FingerPrintScreen.dart';
import 'MorseCodeScreen.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController xLinxController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  XlinxLoginResponse xlinxLoginResponse;
  bool isLoading=false;
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
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/chatlogo.png',
                  height: size.height * 0.65,
                  width: size.width * 0.65,

                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.42,
                  child: EditTextUtils().getCustomEditTextField(
                    hintValue: "输入电子邮件",
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    style: CustomTheme.textFieldTitle,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.015,
                ),
                Container(
                  width: size.width * 0.42,
                  child: EditTextUtils().getCustomEditTextField(
                    hintValue: "@xlinxmail.com",
                    controller: xLinxController,
                    keyboardType: TextInputType.text,
                    style: CustomTheme.textFieldTitle,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            EditTextUtils().getCustomEditTextField(
              hintValue: "Password",
              controller: passwordController,
              keyboardType: TextInputType.text,
              style: CustomTheme.textFieldTitle,
            ),
            SizedBox(
              height: size.height * 0.32,
            ),
            !isLoading?GestureDetector(
              onTap: () {
                LoginAPiFromXlinx();
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
                  children: [Text("立即激活", style: CustomTheme.whiteLargeTitle)],
                ),
              ),
            ):CircularProgressIndicator(backgroundColor: buttonTextColor,),
          ]),
        ));
  }

  Future<void> LoginAPiFromXlinx() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoading = true;
    });
    print("-------------calling API---------------");
    var url =
    Uri.https('nodeapiabc.herokuapp.com', '/api/login');
    print("-----URL_________:::$url");
    Map<String, dynamic> body = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    final headers = {"Accept": "application/x-www-form-urlencoded"};

    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    Response response = await post(
      url,
      body: body,
      headers: headers,
      encoding: encoding,
    );
    int statusCode = response.statusCode;
    String responseBody = response.body;
    print("response::$responseBody");
    print("statuscode::${response.statusCode}");
    if (statusCode == 200) {
      xlinxLoginResponse=XlinxLoginResponse.fromJson(jsonDecode(responseBody));
      if(!xlinxLoginResponse.error)
        {
          setState(() {
            isLoading = false;
          });
          prefs.setString("UserId", xlinxLoginResponse.a);
          prefs.setString("Username", "");
          prefs.setString("email", "");
          prefs.setString("profilePhoto", "");
          prefs.setBool("isLogging", true);
          showAlertDialog(context, xlinxLoginResponse.message);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FingerPrintScreen(),
            ),
          );
        }
      else
        {
          setState(() {
            isLoading = false;
          });
          showAlertDialog(context, xlinxLoginResponse.message);
        }

    }
    else
      {
        setState(() {
          isLoading = false;
        });
      }
  }
}
