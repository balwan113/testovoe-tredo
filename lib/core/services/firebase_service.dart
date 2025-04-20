

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_testovoe_tredo/core/services/notification_service.dart';
import 'package:flutter_testovoe_tredo/firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
 static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;

  FirebaseService._internal();
  
  FirebaseFirestore? _firestore;
  FirebaseAuth? _auth;
  GoogleSignIn? _googleSignIn;
  FirebaseMessaging? _messaging;
  NotificationService? _notificationsService;


  FirebaseFirestore get firestore => _firestore!;
  FirebaseAuth get auth => _auth!;
  GoogleSignIn get googleSignIn => _googleSignIn!;
  FirebaseMessaging get messaging => _messaging!;
  NotificationService get notificationsService => _notificationsService!;



  Future<void> initialize ()async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );

    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
    _googleSignIn = GoogleSignIn();
    _messaging = FirebaseMessaging.instance;
    _notificationsService =NotificationService();

    await _notificationsService!.initialize();


    FirebaseMessaging.onMessage.listen((RemoteMessage message){
 _notificationsService!.showNotificatio(
  title: message.notification?.title ?? 'Новое Сообщение',
      body: message.notification?.body ?? '',
      payload: message.data['chatId'] ?? ''
      );
    });


  await _requestNotificationPermissions(); 
 _messaging!.onTokenRefresh.listen(_saveFcmToken);
    
    final token = await _messaging!.getToken();
    if (token != null) {
      await _saveFcmToken(token);
    }
  }


Future<void> _requestNotificationPermissions() async{
  final settings = await _messaging!.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('Пользователь предоставил Разрешения ${settings.authorizationStatus}');
}


Future<void> _saveFcmToken(String token) async{
  final user =_auth!.currentUser;
  if(user !=null){
    await _firestore!
    .collection('users')
    .doc(user.uid)
    .update({'fcmtoken':token});
  }
}
}