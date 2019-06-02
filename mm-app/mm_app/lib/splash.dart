import 'package:flutter/material.dart';
import 'dart:convert';
import 'utility/jsonManager.dart';
import 'game.dart';
import 'pieces/tile.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  final RuleImport ruleImport = RuleImport();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Map<String, dynamic> gameRules;
  Map<String, dynamic> boardSetup;
  List<BoardTile> gameTiles;

  @override
  void initState() {
    super.initState();
    widget.ruleImport.readJSON('assets/json_imports/rules.json').then((String content) {
      setState(() {
        gameRules = jsonDecode(content);
      });
    });
    widget.ruleImport.readJSON('assets/json_imports/tiles.json').then((String content) {
      setState(() {
        boardSetup  = jsonDecode(content);
        gameTiles = [];
        boardSetup['tiles'].forEach((entry) => gameTiles.add(generateTile(entry)));
      });
    });
  }

  BoardTile generateTile(dynamic jsonEntry){
    return new BoardTile(type: jsonEntry['type'], angle: jsonEntry['angle']);
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
                    MaterialPageRoute(builder: (context) => GameScreen(
                        gameRules: gameRules,
                        gameTiles: gameTiles
                    ))
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
