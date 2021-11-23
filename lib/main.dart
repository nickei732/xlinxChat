import 'dart:convert';
import 'package:XLINXCHAT/provider/ColorsInf.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:XLINXCHAT/model/group_model.dart';
import 'package:XLINXCHAT/model/user_model.dart';
import 'package:XLINXCHAT/provider/DarkThemeProvider.dart';
import 'package:XLINXCHAT/screen/group/chat_screen/chat_screen.dart'
as Group;
import 'package:XLINXCHAT/screen/home/home_screen.dart';
import 'package:XLINXCHAT/screen/person/chat_screen/chat_screen.dart'
as Person;
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/app_state.dart';
import 'package:XLINXCHAT/utils/debug.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screen/IntroScreensWithLogin/FingerPrintScreen.dart';
import 'Presentation/BottomNavigationBar.dart';
import 'screen/IntroScreensWithLogin/SplashScreen1.dart';
import 'model/room_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await firebaseMessaging();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));

  // set development mode true or false
  Debug.isDevelopment = true;
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences prefs;
  bool isInitialized=false;
  ColorsInf colorsInf;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreferceData();
  }

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) {
                return themeChangeProvider;
              },
            ),
          ],
          child: Consumer<DarkThemeProvider>(
            builder: (BuildContext context, value, Widget child) {
              DarkThemeProvider darkThemeProvider =
              Provider.of<DarkThemeProvider>(context);
              return GetMaterialApp(
                  title: 'In AppChat',
                  theme: ThemeData(
                    fontFamily: 'Mulish',
                    cupertinoOverrideTheme: CupertinoThemeData(
                      brightness: Brightness.dark,
                    ),
                  ),
                  debugShowCheckedModeBanner: false,
                  builder: (context, child) {
                    return MediaQuery(
                      child: child,
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    );
                  },
                  home: isInitialized && (prefs.getBool("isLogging")==null||!prefs.getBool("isLogging")  )?SplashScreen1():FingerPrintScreen()

              );
            },
          ),
        );
      },
    );
  }

  Future<void> getPreferceData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isInitialized=true;
    });
  }
}

/// firebase messaging integration
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
AndroidNotificationChannel channel;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

Future<void> firebaseMessaging() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  final IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        print("onSelectNotification Called");
        if (payload != null) {
          final newPay = jsonDecode(payload);
          if (newPay['isGroup'] == "true") {
            print("---------------------------");
            print("isGroup");
            GroupModel groupModel =
            await groupService.getGroupModel(newPay['roomId']);
            Get.offAll(() => new Group.ChatScreen(groupModel, false));
          } else if (newPay['isGroup'] == "false" &&
              newPay['isPersonal'] == "false") {
            print("---------------------------");
            print("Broadcast");
            GroupModel groupModel =
            await groupService.getGroupModel(newPay['roomId']);
            Get.offAll(() => new Group.ChatScreen(groupModel, false));
          } else {
            // todo
            /* print("---------------------------");
        print("isPersonal");
        RoomModel userModel = await chatRoomService.getAllRooms();
        Get.offAll(
            () => new Person.ChatScreen(userModel, false, newPay['roomId']));*/
          }
        }
      });

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("onMessage Called");
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;
    Map<String, dynamic> payload = message.data;
    if (appState.currentActiveRoom != message.data['roomId']) {
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'launch_background',
              ),
            ),
            payload: jsonEncode(payload));
      }
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print("onMessageOpenedApp Called ");
    await Firebase.initializeApp();
    if (message.data['isGroup'] == "true") {
      appState.currentActiveRoom = message.data['roomId'];
      GroupModel groupModel =
      await groupService.getGroupModel(message.data['roomId']);
      Get.to(() => Group.ChatScreen(groupModel, false));
    } else {
      //todo
      /*UserModel userModel = await userService.getUserModel(message.data['id']);
      Get.to(() => Person.ChatScreen(userModel, false, message.data['roomId']));*/
    }
  });

  FirebaseMessaging.instance
      .getInitialMessage()
      .then((RemoteMessage message) async {
    print("getInitialMessage Called ");
    if (message != null) {
      await Firebase.initializeApp();
      if (message.data['isGroup'] == "true") {
        GroupModel groupModel =
        await groupService.getGroupModel(message.data['roomId']);
        Get.to(() => Group.ChatScreen(groupModel, false));
      } else {
        // todo
        /*  UserModel userModel =
            await userService.getUserModel(message.data['id']);
        Get.to(
            () => Person.ChatScreen(userModel, false, message.data['roomId']));*/
      }
    }
  });
}

Future onDidReceiveLocalNotification(
    int id,
    String title,
    String body,
    String payload,
    ) async {
  print("iOS notification $title $body $payload");
}
