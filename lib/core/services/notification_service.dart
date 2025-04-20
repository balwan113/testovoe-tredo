


import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize ()async{
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
      );
  }

  void _onDidReceiveNotificationResponce(NotificationResponse details){
    final payload = details.payload;
    if(payload !=null){
      print('Notification payload: $payload');
    }
  }


  Future<void> showNotificatio({
    required String title,
    required String body,
    String? payload,
  })async{
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'chat_channel',
     'Увидомление',
  channelDescription: 'уведомления о новых сообщениях чата',
  importance: Importance.max,
  priority: Priority.high,
  showWhen: true
    );

    const DarwinNotificationDetails IOSPlatformChannelSpecifics =
    DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: IOSPlatformChannelSpecifics
    );

    await _notificationsPlugin.show(0, 
    title,
    body,
    platformChannelSpecifics,
    payload: payload
    );
  }
}