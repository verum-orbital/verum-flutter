import 'package:flutter/material.dart';
// Testing Pull Request
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false;
      title: 'Verum',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
