import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';

import 'auth.dart';
import 'database_methods.dart';

class NotificationsMethod {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> updateFirebaseMessagingToken() async {
    await firebaseMessaging.requestPermission();
    await firebaseMessaging.getToken().then((value) {
      if (value != null) {
        print("fcm_token : ${value}");
        DatabaseMethod()
            .firestore
            .collection("users")
            .doc(Auth().currentUser!.uid)
            .update({"fcm_token": value});
      }
    });
  }

  static Future<String?> getFirebaseMessagingTokenFromUser(
      String userId) async {
    String? fcmToken;
    await DatabaseMethod()
        .firestore
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
      fcmToken = value['fcm_token'];
    });
    print("token: ${fcmToken}");
    return fcmToken;
  }

  static Future<void> setFirebaseMessagingToken(String string) async {
    DatabaseMethod()
        .firestore
        .collection("users")
        .doc(Auth().currentUser!.uid)
        .update({"fcm_token": string});
  }

  static Future<void> sendPushNotificationText(
      String? token, String message) async {
    try {
      if (token != "" || token!.isNotEmpty) {
        final body = {
          "to": token,
          "notification": {"title": "Dr.Sulthan", "body": message}
        };

        var res = await post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader:
                  'key=AAAAIlKGraI:APA91bGc5jzsiGW_K4pmA4OAiTMnTuwS0onKkMlbL28Q5rnmvKM5DmWbyMM9hpiOBBThr3wnY80n2tkhu3J2Vsbf1DlrnTAiVsX3vU3QEktMbJ9HyGyXqYr04jlf6cKNhPEEWZakZbpR'
            },
            body: jsonEncode(body));

        print('response status : ${res.statusCode}');
        print('response body : ${res.body}');
      } else {
        print('token null');
      }
    } catch (e) {
      print("sendNotification: $e");
    }
  }

  static Future<void> sendPushNotificationTextGeneral(
      String? token, String title, String message) async {
    try {
      if (token != "" || token!.isNotEmpty) {
        final body = {
          "to": token,
          "notification": {"title": title, "body": message}
        };

        var res = await post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader:
                  'key=AAAAIlKGraI:APA91bGc5jzsiGW_K4pmA4OAiTMnTuwS0onKkMlbL28Q5rnmvKM5DmWbyMM9hpiOBBThr3wnY80n2tkhu3J2Vsbf1DlrnTAiVsX3vU3QEktMbJ9HyGyXqYr04jlf6cKNhPEEWZakZbpR'
            },
            body: jsonEncode(body));

        print('response status : ${res.statusCode}');
        print('response body : ${res.body}');
      } else {
        print('token null');
      }
    } catch (e) {
      print("sendNotification: $e");
    }
  }

  static Future<void> sendPushNotificationImage(
      String? token, String imagePath) async {
    try {
      if (token != "" || token!.isNotEmpty) {
        final body = {
          "to": token,
          "notification": {"title": "Dr.Sulthan", "image": imagePath}
        };

        var res = await post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader:
                  'key=AAAAIlKGraI:APA91bGc5jzsiGW_K4pmA4OAiTMnTuwS0onKkMlbL28Q5rnmvKM5DmWbyMM9hpiOBBThr3wnY80n2tkhu3J2Vsbf1DlrnTAiVsX3vU3QEktMbJ9HyGyXqYr04jlf6cKNhPEEWZakZbpR'
            },
            body: jsonEncode(body));

        print('response status : ${res.statusCode}');
        print('response body : ${res.body}');
      } else {
        print('token null');
      }
    } catch (e) {
      print("sendNotification: $e");
    }
  }
}
