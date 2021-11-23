import 'package:flutter/material.dart';
import 'package:XLINXCHAT/style/theme.dart';
import '../../Colors.dart';
import 'SplashScreen4.dart';

class SplashScreen3 extends StatefulWidget {

  @override
  _SplashScreen3State createState() => _SplashScreen3State();
}

class _SplashScreen3State extends State<SplashScreen3> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.only(top: size.height*0.330),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/page3bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '需要安全',
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
                  '不是因为我脆弱',
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: size.height * 0.022,
                      color: whiteTextColor,
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: size.height * 0.29,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen4()),
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
                        Text("结束", style: CustomTheme.whiteLargeTitle)
                      ],
                    ),
                  ),
                ),
              ]),
        ));
  }
}


