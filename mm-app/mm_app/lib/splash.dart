import 'package:flutter/material.dart';
import 'dart:convert';
import 'utility/jsonManager.dart';
import 'game.dart';
import 'pieces/tile.dart';
import 'pieces/player.dart';
import 'package:mm_app/models/app_constants.dart';


class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  final JSONManager ruleImport = JSONManager();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Map<String, dynamic> gameRules;
  Map<String, dynamic> boardSetup;
  List<BoardTile> gameTiles;
  List<MaterialColor> colours;
  List<String> targets;
  List<Player> players;

  @override
  void initState() {
    super.initState();
    widget.ruleImport.readJSON('assets/json_imports/rules.json').then((String content) {
      setState(() {
        gameRules = jsonDecode(content);
      });
    });
    widget.ruleImport.readJSON('assets/json_imports/setup.json').then((String content) {
      setState(() {
        boardSetup  = jsonDecode(content);
        gameTiles = [];
        players = [];
        targets = generateTargetList(gameRules['targets']);
        boardSetup['players'].forEach( (entry) => players.add(generatePlayer(entry)));
        boardSetup['tiles'].forEach((entry) => gameTiles.add(generateTile(entry)));
        });
    });
  }

  BoardTile generateTile(dynamic jsonEntry){
    return new BoardTile(type: jsonEntry['type'], angle: jsonEntry['angle'], target: (jsonEntry['targetId']!=null) ?targets[jsonEntry['targetId']] :null);
  }

  Player generatePlayer(dynamic jsonEntry){
    return new Player(name: jsonEntry['name'], colour: colours[players.length],);
  }

  List<String> generateTargetList(int num){
    targets = AppStateContainer.of(context).getTargets().sublist(0, num);
    targets.shuffle();
    return targets;
  }

  @override
  Widget build(BuildContext context) {
    colours = AppStateContainer.of(context).getColours();

    return Scaffold(
      appBar: AppBar(
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
                        gameTiles: gameTiles,
                        targets: targets,
                        players: players
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
