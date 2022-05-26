import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Verum',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      // home: const ResponsiveLayout(
      //     webScreenLayout: WebScreenLayout(),
      //     mobileScreenLayout: MobileScreenLayout(),
      //     ),
      home: LoginScreen(),
    );
  }
}
