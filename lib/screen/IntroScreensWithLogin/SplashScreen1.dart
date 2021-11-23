import 'package:flutter/material.dart';
import 'package:XLINXCHAT/style/theme.dart';


import '../../Colors.dart';
import '../../Presentation/rounded_button.dart';
import 'SplashScreen2.dart';

class SplashScreen1 extends StatefulWidget {

  @override
  _SplashScreen1State createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
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
              image: AssetImage("assets/page1bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  Text(
                    '选择匿名',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: size.height * 0.029,
                        color: whiteTextColor,
                        fontWeight: FontWeight.bold),
                  ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Text(
                  '不是因为我普通',
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: size.height * 0.022,
                      color: whiteTextColor,
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: size.height * 0.45,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen2()),
                    );
                  },
                  child: Container(
                    height: size.height*0.065,
                    margin: EdgeInsets.only(top: size.height*0.1,left: size.width*0.045,right: size.width*0.045),
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
                        Text("下一步", style: CustomTheme.whiteLargeTitle)
                      ],
                    ),
                  ),
                ),
              ]),
        ));
  }
}


