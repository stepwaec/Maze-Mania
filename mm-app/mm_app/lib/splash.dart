import 'package:flutter/material.dart';
import 'dart:convert';
import 'utility/jsonManager.dart';
import 'game.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  final RuleImport ruleImport = RuleImport();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Map<String, dynamic> gameRules;

  @override
  void initState() {
    super.initState();
    widget.ruleImport.readRules().then((String content) {
      setState(() {
        gameRules = jsonDecode(content);
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Start New Game'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen(gameRules: gameRules))
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
