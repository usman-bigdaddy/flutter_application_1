import 'package:flutter/material.dart';
import 'Home.dart';
import 'Loading.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {'/': (context) => Loading(), '/Home': (context) => Home()},
    );
  }
}
