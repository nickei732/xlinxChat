import 'package:flutter/material.dart';
import 'package:XLINXCHAT/screen/login/sign_in_screen.dart';
import 'package:XLINXCHAT/style/theme.dart';
import '../../Colors.dart';
import 'LoginPage.dart';

class SplashScreen4 extends StatefulWidget {

  @override
  _SplashScreen4State createState() => _SplashScreen4State();
}

class _SplashScreen4State extends State<SplashScreen4> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.only(top: size.height*0.11),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/page4bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/chatlogo.png',
                          height: size.height * 0.7,
                          width: size.width * 0.7,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
                Text(
                  '条款和隐私政策',
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: size.height * 0.022,
                      color: blueshColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: size.height * 0.035,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Container(
                    height: size.height*0.065,
                    margin: EdgeInsets.only(left: size.width*0.045,right: size.width*0.045),
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
                      children: [
                        Text("立即激活", style: CustomTheme.whiteLargeTitle)
                      ],
                    ),
                  ),
                ),
              ]),
        ));
  }
}


