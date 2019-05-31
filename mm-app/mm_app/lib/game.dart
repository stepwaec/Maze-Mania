import 'package:flutter/material.dart';
import 'pieces/tile.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key key, this.gameRules}) : super(key: key);
  final Map<String, dynamic> gameRules;

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  BoardTile _floatTile = BoardTile(angle: 0,target: null,tile: new TileDesign());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _floatTile
            ,
            Text(
                'Grid size is (rows:${widget.gameRules['grid_rows']}, columns:${widget.gameRules['grid_columns']})'
            ),
          ],
        ),
      ),
    );
  }
}
