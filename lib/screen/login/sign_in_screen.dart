import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'package:XLINXCHAT/model/LoginResponse.dart';
import 'package:XLINXCHAT/provider/ColorsInf.dart';
import 'package:XLINXCHAT/provider/DarkThemeProvider.dart';
import 'package:XLINXCHAT/screen/home/home_screen.dart';
import 'package:XLINXCHAT/screen/login/sign_in_view_model.dart';
import 'package:XLINXCHAT/screen/register/sign_up_screen.dart';
import 'package:XLINXCHAT/style/theme.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/common_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import '../IntroScreensWithLogin/FingerPrintScreen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  LoginResponse loginResponse;
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  DarkThemeProvider themeChange;
  ColorsInf colorsInf;

  @override
  Widget build(BuildContext context) {
    themeChange = Provider.of<DarkThemeProvider>(context);
    colorsInf = getColor(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ColorRes.white,
      body: ViewModelBuilder<SignInViewModel>.reactive(
        onModelReady: (model) async {
          model.init();
        },
        viewModelBuilder: () => SignInViewModel(),
        builder: (context, model, child) {
          return SafeArea(
            child: Stack(
              children: [
                Form(
                  key: model.formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          height: size.height * 0.38,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/chatlogo.png',
                                      height: size.height * 0.35,
                                      width: size.width * 0.65,
                                      fit: BoxFit.fill),
                                ],
                              ),
                              verticalSpaceSmall,
                            ],
                          ),
                        ),
                        verticalSpaceMassive,
                        Container(
                          padding: EdgeInsets.only(top: 0.0),
                          height: MediaQuery.of(context).size.height / 1.5,
                          color: ColorRes.white,
                          child: Column(
                            children: [
                              TextFieldWidget(
                                controller: model.emailController,
                                title: "用户名",
                                readOnly: model.isBusy,
                              ),
                              TextFieldWidget(
                                controller: model.passwordController,
                                title: "密码",
                                obs: true,
                                readOnly: model.isBusy,
                              ),
                              SizedBox(
                                height: size.height * 0.13,
                              ),
                              Padding(
                                padding: EdgeInsets.all(20.0),
                                child: model.isBusy
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: ColorRes.green,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: EdgeInsets.all(4),
                                        child: Center(
                                          child: Platform.isMacOS
                                              ? CupertinoActivityIndicator()
                                              : CircularProgressIndicator(),
                                        ),
                                      )
                                    : isLoading
                                        ? CircularProgressIndicator(
                                            backgroundColor: ColorRes.green,
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              checkValidation(model);
                                            },
                                            child: Container(
                                              height: size.height * 0.065,
                                              margin: EdgeInsets.only(
                                                  left: size.width * 0.045,
                                                  right: size.width * 0.045),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    Color(0xff0D9FCC),
                                                    Color(0xff15255D)
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text("密码",
                                                      style: CustomTheme
                                                          .whiteLargeTitle)
                                                ],
                                              ),
                                            ),
                                          ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                    size: 30.h,
                    color: ColorRes.green,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> login(SignInViewModel model) async {
    print(model.emailController.text);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoading = true;
      /*  model.emailController.text="supermovie";
      model.passwordController.text="123123";*/
    });
    print("-------------calling API---------------");
    var url =
        Uri.http('www.harisangam.com', '/index.php/api/user/test/user-login');
    print("-----URL_________:::$url");
    Map<String, dynamic> body = {
      'user_name': model.emailController.text,
      'user_password': model.passwordController.text,
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
      loginResponse = LoginResponse.fromJson(jsonDecode(responseBody));
      if (loginResponse.status == "success") {
        prefs.setString("UserId", loginResponse.data.hariUserid);
        prefs.setString("Username", loginResponse.data.hariUsername);
        prefs.setString("email", loginResponse.data.hariUseremail);

        prefs.setString("profilePhoto", "");
        prefs.setBool("isLogging", true);
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FingerPrintScreen(),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        showAlertDialog(context, "Wrong Username or password");
      }
    }
  }

  void checkValidation(SignInViewModel model) {
    if (model.emailController.text.isEmpty) {
      showAlertDialog(context, "请输入用户名");
    } else if (model.passwordController.text.isEmpty) {
      showAlertDialog(context, "请输入密码");
    } else {
      login(model);
    }
  }
}

showAlertDialog(BuildContext context, String messege) {
  Size size = MediaQuery.of(context).size;
  // set up the button
  Widget okButton = FlatButton(
    child: Text(
      "好的",
      style: TextStyle(
          fontFamily: 'Mulish',
          color: ColorRes.green,
          fontSize: size.height * 0.022,
          fontWeight: FontWeight.normal),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: Text(
      messege,
      style: TextStyle(
          fontFamily: 'Mulish',
          fontSize: size.height * 0.022,
          fontWeight: FontWeight.normal),
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
