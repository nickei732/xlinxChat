import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:XLINXCHAT/model/send_notification_model.dart';

class MessagingService {
  FirebaseMessaging message = FirebaseMessaging.instance;
  static const String serverToken =
      'AAAAahJZ2QU:APA91bGwSh2Y3NZx6N3dwhxQ1q5kB4rmPGyXb1eOCds-M8CNRXpBajaL1aMvRMZB845NXTEGHymC7Eo_x-K-AtoaNNcFREzIp5ApTibxlBAW7KQDDe3xdfXz5lkkgi_HvLExNMya4JQV';

  Future<String> getFcmToken() async {
    return await message.getToken();
  }

  void sendNotification(SendNotificationModel notification) async {
    print("token = ${notification.fcmTokens}");
    Response response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(notification.toMap()),
    );

    print(response.statusCode);
    print(response.body);
  }
}
