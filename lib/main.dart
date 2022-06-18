import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verum_flutter/providers/user_provider.dart';
import 'package:verum_flutter/resources/push_notification_service.dart';
import 'package:verum_flutter/responsive/mobile_screen_layout.dart';
import 'package:verum_flutter/responsive/responsive_layout_screen.dart';
import 'package:verum_flutter/responsive/web_screen_layout.dart';
import 'package:verum_flutter/screens/login_screen.dart';
import 'package:verum_flutter/screens/signup_screen.dart';
import 'package:verum_flutter/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyCD_aGzAggHQ4yg0WQ0yJCT5rBbYHIeU3o',
        appId: '1:132209873388:web:1c54e0abce3201b059b0c9',
        messagingSenderId: '132209873388',
        projectId: 'verum-4bd2b',
        storageBucket: 'verum-4bd2b.appspot.com',
      ),
    );
  } else {
    await Firebase.initializeApp();
    Future<void> _firebaseMessagingBackgroundHandler(
        RemoteMessage message) async {
      // If you're going to use other Firebase services in the background, such as Firestore,
      // make sure you call `initializeApp` before using other Firebase services.
      await Firebase.initializeApp();

      print("Handling a background message: ${message.messageId}");
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp
        .listen((data) => print('Launched with $data'));

    FirebaseMessaging.onMessage.listen((message) {
      print("onMessage: $message");
      print("data: ${message.data}");
      if (Platform.isIOS) {
        // final notification = PushNotificationMessage(
        //   title: message. ['aps']['alert']['title'],
        //   body: message['aps']['alert']['body'],
        // );
        // showSimpleNotification(
        //   Container(child: Text(notification.body)),
        //   position: NotificationPosition.top,
        // );
      }
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final pushNotificationService = PushNotificationService(_firebaseMessaging);
    pushNotificationService.initialise();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Verum',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              ));
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
