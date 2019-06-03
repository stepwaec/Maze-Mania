import 'package:flutter/material.dart';
import 'pieces/tile.dart';
import 'pieces/grid.dart';
import 'pieces/player.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key key, this.gameRules, this.gameTiles, this.players}) : super(key: key);
  final Map<String, dynamic> gameRules;
  final List<BoardTile> gameTiles;
  List<Player> players;

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
    _blockTiles(widget.gameRules['tile_lock']);
    for(int i = 0; i<widget.players.length; i++){ // Set position of players
      _setStartingTile(i);
    }
  }

  void _blockTiles(pattern){
    if(pattern == 'alternate'){
      // All odd columns/rows should be locked
      List <BoardTile> boardSubset = [];
      for(var col = 1; col < widget.gameRules['grid_columns']; col+=2){
        boardSubset = _getColumn(col);
        boardSubset[0].setMovable(false);
        boardSubset[widget.gameRules['grid_columns']-1].setMovable(false);
      }
      for(var row = 1; row < widget.gameRules['grid_rows']; row+=2){
        boardSubset = _getRow(row);
        boardSubset[0].setMovable(false);
        boardSubset[widget.gameRules['grid_rows']-1].setMovable(false);
      }
    }
  }

  // Max of 8 players for this game setup
  void _setStartingTile(playerNumber){  // Sequentially invoked, assumes max_number is checked
    /*
    PATTERN:   P1 - P7 - P4
               -  - -  - -
               P5 - -  - P6
               -  - -  - -
               P3 - P8 - P2

     */
    switch (playerNumber) {
      case 0: // First tile
        int target = 0;
        widget.gameTiles[target].content = "P1";
        widget.players[playerNumber].position = target;
        break;
      case 1: // Last tile
        int target = widget.gameTiles.length-1;
        widget.gameTiles[target].content = "P2";
        widget.players[playerNumber].position = target;
        break;
      case 2: // Beginning of last row
        int target = widget.gameTiles.length - widget.gameRules['grid_columns'];
        widget.gameTiles[target].content = "P3";
        widget.players[playerNumber].position = target;
        break;
      case 3: // End of first row
        int target = widget.gameRules['grid_columns']-1;
        widget.gameTiles[target].content = "P4";
        widget.players[playerNumber].position = target;
        break;
      case 4: // Beginning of middle row
        int target = (widget.gameRules['grid_rows']/2 - 1).round() * widget.gameRules['grid_columns'];
        widget.gameTiles[target].content = "P5";
        widget.players[playerNumber].position = target;
        break;
      case 5: // End of middle row
        int target =  (widget.gameRules['grid_rows']/2).round() * widget.gameRules['grid_columns'] - 1;
        widget.gameTiles[target].content = "P6";
        widget.players[playerNumber].position = target;
        break;
      case 6: // Middle of first row
        int target = (widget.gameRules['grid_columns']/2 - 1).round();
        widget.gameTiles[target].content = "P7";
        widget.players[playerNumber].position = target;
        break;
      case 7: // Middle of last row
        int target = widget.gameTiles.length - (widget.gameRules['grid_columns']/2).round();
        widget.gameTiles[target].content = "P8";
        widget.players[playerNumber].position = target;
        break;
    }
  }

  List<BoardTile> _getColumn(number){
    List <BoardTile> result = [];
    for( int tileIndex = number % widget.gameRules['grid_columns']; tileIndex < widget.gameTiles.length; tileIndex += widget.gameRules['grid_columns']){
      result.add(widget.gameTiles[tileIndex]);
    }
   return result;
  }

  List<BoardTile> _getRow(number){
    List <BoardTile> result = [];
    int start = (number % widget.gameRules['grid_rows']) * widget.gameRules['grid_columns'];
    int end = start + widget.gameRules['grid_rows'];
    for( int tileIndex = start; tileIndex < end; tileIndex++){
      result.add(widget.gameTiles[tileIndex]);
    }
    return result;
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
            width: widget.gameRules['grid_columns'] * 50.0,
            height: widget.gameRules['grid_rows'] * 50.0,
          child:
            GameGrid(gameRules: widget.gameRules, gameTiles: widget.gameTiles),
        ),ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 150.0,
          minWidth: 150.0,
          maxHeight: 150.0,
          maxWidth: 150.0,
        ), child: GestureDetector(
              onTap: (){
                _rotateTile();
              }, child: RotatedBox(
                  quarterTurns: (_floatAngle / 90).round(),
                  child:  _floatTile
              )
          ))],
        ),
      ),
    );
  }
}
