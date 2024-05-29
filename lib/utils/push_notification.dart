import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:materialx_flutter/model/notif.dart';
import 'package:materialx_flutter/utils/notification_route.dart';

class PushNotification {
  static const String CHANNEL_ID_NAME = "Default";
  static Random random = Random();

  BuildContext? context;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  PushNotification.init(this.context){
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = const AndroidInitializationSettings('app_icon');
    var iOS = const DarwinInitializationSettings();
    var initSettings = InitializationSettings(android: android, iOS: iOS);

    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onSelectNotification, // Updated to use the correct callback
    );

    _requestPermissions();
  }

  Future _onSelectNotification(NotificationResponse response) async {
    String? payload = response.payload;
    if (payload != null && context != null) {
      await Navigator.push(context!, MaterialPageRoute(builder: (BuildContext context){
        Notif? notif = getNotifObject(payload);
        return notif == null ? ListNotificationRoute() : DialogNotificationRoute(notif, true, null);
      }));
    }
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
        );

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
        );
  }

  Future<void> showNotification(Notif notif) async {
    var android = const AndroidNotificationDetails(
      CHANNEL_ID_NAME, CHANNEL_ID_NAME,
      priority: Priority.high, importance: Importance.max,
    );
    var iOS = const DarwinNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
      random.nextInt(1000), notif.title, notif.content,
      platform, payload: getNotifJson(notif)
    );
  }

  Notif? getNotifObject(String json){
    try {
      Map<String, dynamic> map = jsonDecode(json);
      Notif notif = Notif.fromJson(map);
      return notif;
    } catch (error) {
      return null;
    }
  }

  String getNotifJson(Notif obj){
    return jsonEncode(obj);
  }
}
