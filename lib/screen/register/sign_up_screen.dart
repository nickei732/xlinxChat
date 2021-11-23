import 'dart:convert';
import 'dart:io';

import 'package:XLINXCHAT/screen/IntroScreensWithLogin/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'package:XLINXCHAT/model/RegisterResposne.dart';
import 'package:XLINXCHAT/provider/ColorsInf.dart';
import 'package:XLINXCHAT/provider/DarkThemeProvider.dart';
import 'package:XLINXCHAT/screen/home/home_screen.dart';
import 'package:XLINXCHAT/screen/login/sign_in_screen.dart';
import 'package:XLINXCHAT/screen/register/sign_up_view_model.dart';
import 'package:XLINXCHAT/style/theme.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/common_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  DarkThemeProvider themeChange;
  ColorsInf colorsInf;
  bool isLoading = false;
  RegisterRepsonse loginResponse;

  @override
  Widget build(BuildContext context) {
    themeChange = Provider.of<DarkThemeProvider>(context);
    colorsInf = getColor(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorRes.background,
      body: ViewModelBuilder<SignUpViewModel>.reactive(
        onModelReady: (model) async {
          model.init();
        },
        viewModelBuilder: () => SignUpViewModel(),
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
                                controller: model.nameController,
                                title: "用户名",
                                readOnly: model.isBusy,
                              ),
                              TextFieldWidget(
                                controller: model.passwordController,
                                title: "密码",
                                obs: true,
                                readOnly: model.isBusy,
                              ),
                              TextFieldWidget(
                                controller: model.confirmPasswordController,
                                title: "确认密码",
                                readOnly: model.isBusy,
                              ),
                              SizedBox(
                                height: size.height * 0.05,
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
                                                  Text("立即激活",
                                                      style: CustomTheme
                                                          .whiteLargeTitle)
                                                ],
                                              ),
                                            ),
                                          ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: size.width * 0.1),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("已经注册？登录",
                                          style: CustomTheme.textFieldTitle)
                                    ],
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

  Future<void> login(SignUpViewModel model) async {
    print(model.emailController.text);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoading = true;
      /*  model.emailController.text="supermovie";
      model.passwordController.text="123123";*/
    });
    print("-------------calling API---------------");
    var url = Uri.http(
        'www.harisangam.com', '/index.php/api/user/test/user-register');
    print("-----URL_________:::$url");
    Map<String, dynamic> body = {
      'customer_email': model.nameController.text,
      'customer_password': model.passwordController.text,
      'confirm_password': model.confirmPasswordController.text,
      'customer_fname': "",
    };

    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    Response response = await post(
      url,
      body: body,
      encoding: encoding,
    );
    int statusCode = response.statusCode;
    String responseBody = response.body;
    print("response::$responseBody");
    print("statuscode::${response.statusCode}");
    if (statusCode == 200) {
      loginResponse = RegisterRepsonse.fromJson(jsonDecode(responseBody));
      if (loginResponse.status == "success") {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignInScreen(),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        showAlertDialog(context, loginResponse.data.msg);
      }
    }
  }

  void checkValidation(SignUpViewModel model) {
    if (model.nameController.text.isEmpty) {
      showAlertDialog(context, "请输入用户名");
    } else if (model.passwordController.text.isEmpty) {
      showAlertDialog(context, "请输入密码");
    } else if (model.confirmPasswordController.text.isEmpty) {
      showAlertDialog(context, "请输入确认密码");
    } else if (model.passwordController.text !=
        model.confirmPasswordController.text) {
      showAlertDialog(context, "确认密码字段与密码不匹配");
    } else {
      login(model);
    }
  }
}
