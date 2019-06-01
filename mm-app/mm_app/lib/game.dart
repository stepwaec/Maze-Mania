import 'package:flutter/material.dart';
import 'pieces/tile.dart';
import 'pieces/grid.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key key, this.gameRules}) : super(key: key);
  final Map<String, dynamic> gameRules;

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  BoardTile _floatTile = BoardTile(angle: 0, type: 'corner', treasure: null);
  int _floatAngle = 0;

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
          children: <Widget>[
            SizedBox(
            width: 500.0,
            height: 500.0,
          child:
            GameGrid(gameRules: widget.gameRules,),
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
