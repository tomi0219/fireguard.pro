import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import  'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart';

class LocalNotificationService{
  LocalNotificationService();
  final localNotificationService = FlutterLocalNotificationsPlugin();
   final localiosNotificationService = IOSFlutterLocalNotificationsPlugin();
  Future<void> initialize() async{
    const AndroidInitializationSettings androidInitializationSettings =AndroidInitializationSettings('ic_launcher');
  
    

      var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: initializationSettingsIOS);
    await localNotificationService.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  // Future showNotification(
  //     {int id = 0, String? title, String? body, String? payLoad}) async {
  //   return localNotificationService.show(
  //       id, title, body, await notificationDetails());

  // }
void showNotification(String title , String body , int id ) async {
  const channelId = "id";
  const channelName = 'Alarm Channel';
  const channelDesc = 'Channel for alarm notifications';

  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    channelId,
    channelName,
   channelDescription: channelDesc,
    importance: Importance.max,
    priority: Priority.max,
    ticker: 'ticker',
    playSound: true,
  styleInformation: MediaStyleInformation()
  );

  final platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await FlutterLocalNotificationsPlugin().show(
    id,
   title,
   body,
    platformChannelSpecifics,
    payload: 'Custom alarm payload',
  );
}
  void onDidReceiveNotificationResponse(int id, String title, String body, String payload) {
  print('id $id');
  }
  
  
}

