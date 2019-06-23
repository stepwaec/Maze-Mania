import 'package:flutter/material.dart';
import 'package:mm_app/models/app_constants.dart';
import 'splash.dart';

void main() => runApp(AppStateContainer(child: MyApp()) );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maze Mania',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: SplashScreen(),
    );
  }
}