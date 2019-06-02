import 'package:flutter/material.dart';
import 'pieces/tile.dart';
import 'pieces/grid.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key key, this.gameRules, this.gameTiles}) : super(key: key);
  final Map<String, dynamic> gameRules;
  final List<BoardTile> gameTiles;

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  BoardTile _floatTile;
  int _floatAngle = 0;

  @override
  void initState(){
    super.initState();
    _floatTile = widget.gameTiles.removeLast();
  }

  void _rotateTile() {
    setState(() {
      _floatAngle = (_floatAngle + 90) % 360;
    });
  }

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
            width: widget.gameRules['grid_columns'] * 50.0,
            height: widget.gameRules['grid_rows'] * 50.0,
          child:
            GameGrid(gameRules: widget.gameRules, gameTiles: widget.gameTiles),
        ),
        GestureDetector(
            onTap: (){
              _rotateTile();
            },
            child: RotatedBox(
                quarterTurns: (_floatAngle / 90).round(),
                child: _floatTile
            )
        )
          ],
        ),
      ),
    );
  }
}
