import 'package:flutter/material.dart';
import 'pieces/tile.dart';
import 'pieces/grid.dart';
import 'pieces/player.dart';
import 'pieces/inserter.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key key, this.gameRules, this.gameTiles, this.targets, this.players}) : super(key: key);
  final Map<String, dynamic> gameRules;
  final List<BoardTile> gameTiles;
  final List<String> targets;
  List<Player> players;

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  BoardTile _floatTile;
  int _floatAngle;  // Independent from tile angle (starts at 0)

  @override
  void initState(){
    super.initState();
    _floatTile = widget.gameTiles.removeLast();
    _floatAngle = 0;
    _blockTiles(widget.gameRules['tile_lock']);
    for(int i = 0; i<widget.players.length; i++){ // Set position of players
      _setStartingTile(i);
    }
  }

  // INITIALISATION FUNCTIONS
  void _blockTiles(pattern){
    if(pattern == 'alternate'){
      // All odd columns/rows should be locked
      List <BoardTile> boardSubset = [];
      for(var col = 0; col < widget.gameRules['grid_columns']; col+=2){
        boardSubset = _getColumn(col);
        boardSubset[0].setMovable(false);
        boardSubset[widget.gameRules['grid_columns']-1].setMovable(false);
      }
      for(var row = 0; row < widget.gameRules['grid_rows']; row+=2){
        boardSubset = _getRow(row);
        boardSubset[0].setMovable(false);
        boardSubset[widget.gameRules['grid_rows']-1].setMovable(false);
      }
    }
  }

  // Max of 8 players for this game setup
  void _setStartingTile(playerId){  // Sequentially invoked, assumes max_number is checked
    /*
    PATTERN:   P1 - P7 - P4
               -  - -  - -
               P5 - -  - P6
               -  - -  - -
               P3 - P8 - P2

     */
    switch (playerId) {
      case 0: // First tile
        int target = 0;
        widget.gameTiles[target].setStartingPosition(playerId, widget.players[playerId].colour);
        break;
      case 1: // Last tile
        int target = widget.gameTiles.length-1;
        widget.gameTiles[target].setStartingPosition(playerId, widget.players[playerId].colour);
        break;
      case 2: // Beginning of last row
        int target = widget.gameTiles.length - widget.gameRules['grid_columns'];
        widget.gameTiles[target].setStartingPosition(playerId, widget.players[playerId].colour);
        break;
      case 3: // End of first row
        int target = widget.gameRules['grid_columns']-1;
        widget.gameTiles[target].setStartingPosition(playerId, widget.players[playerId].colour);
        break;
      case 4: // Beginning of middle row
        int target = (widget.gameRules['grid_rows']/2 - 1).round() * widget.gameRules['grid_columns'];
        widget.gameTiles[target].setStartingPosition(playerId, widget.players[playerId].colour);
        break;
      case 5: // End of middle row
        int target =  (widget.gameRules['grid_rows']/2).round() * widget.gameRules['grid_columns'] - 1;
        widget.gameTiles[target].setStartingPosition(playerId, widget.players[playerId].colour);
        break;
      case 6: // Middle of first row
        int target = (widget.gameRules['grid_columns']/2 - 1).round();
        widget.gameTiles[target].setStartingPosition(playerId, widget.players[playerId].colour);
        break;
      case 7: // Middle of last row
        int target = widget.gameTiles.length - (widget.gameRules['grid_columns']/2).round();
        widget.gameTiles[target].setStartingPosition(playerId, widget.players[playerId].colour);
        break;
    }
  }

  Widget _getInserters(side, type, number, pattern) {
    double containerWidth = (type == 'column') ? 50.0 : 25.0;
    double containerHeight = (type == 'column') ? 25.0 : 50.0;

    if (pattern == 'alternate') {
      return
        SizedBox(
          height: (type == 'column') ? 25.0 : widget.gameRules['grid_columns'] * 50.0,
          width: (type == 'column') ? widget.gameRules['grid_rows'] * 50.0 : 25.0,
          child:

          ListView.builder(
            itemCount: (type == 'column') ? widget.gameRules['grid_columns'] : widget.gameRules['grid_rows'],
            scrollDirection: (type == 'column') ? Axis.horizontal : Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Container(
          child:
          Container(
            width: containerWidth,
            height: containerHeight,
            margin: EdgeInsets.only(
              top: (type == 'row') ? 50.0 : 0.0,
              left: (type == 'column') ? 50.0 : 0.0,
            ),
            padding: EdgeInsets.only(
              top: (type == 'column' && side == 'end') ? 5.0 : 0.0,
              bottom: (type == 'column' && side == 'start') ? 5.0 : 0.0,
              left: (type == 'row' && side == 'end') ? 5.0 : 0.0,
              right: (type == 'row' && side == 'start') ? 5.0 : 0.0,
            ),
            alignment: Alignment.bottomCenter,
            child:
                GestureDetector(
                  onTap: (){_transferFloat(type, side, _getRCIndex(index));},
                child: SizedBox(
                    height: (type == 'column') ? 20.0 : 40.0,
                    width: (type == 'column') ? 40.0 : 20.0,
                    child:
                    new Inserter(type: type, side: side, index: _getRCIndex(index),)
                ),)
          ));
        },)
    );
    }
  }

  // SUPPORT FUNCTIONS
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

  int _getRCIndex(number){
    int blanks = number + 1;
    int used = number + 1;
    return blanks + used - 1;
  }

  int _getTileIndex(row, column){
    return row * (widget.gameRules['grid_rows'] - 1) + column * (widget.gameRules['grid_columns'] - 1);
  }

  // PLAY FUNCTIONS
  void _transferFloat(type, side, index ) {
    print("TRANSFER: $type, $side, $index");
  }

  void _rotateFloat() {
    setState(() {
      _floatAngle = (_floatAngle + 90) % 360;
      _floatTile.angle = (_floatTile.angle + 90) % 360;
      print(_floatTile.getMoveOptions().toString());
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _getInserters(
                  'start',
                  'column',
                  widget.gameRules['grid_columns'],
                  widget.gameRules['tile_lock']
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            _getInserters(
                    'start',
                    'row',
                    widget.gameRules['grid_rows'],
                    widget.gameRules['tile_lock']
            ),
            SizedBox(
            width: widget.gameRules['grid_columns'] * 50.0,
            height: widget.gameRules['grid_rows'] * 50.0,
              child:
                GameGrid(gameRules: widget.gameRules, gameTiles: widget.gameTiles),
            ),
            _getInserters(
                'end',
                'row',
                widget.gameRules['grid_rows'],
                widget.gameRules['tile_lock']
            ),
          ]),

            _getInserters(
                'end',
                'column',
                widget.gameRules['grid_columns'],
                widget.gameRules['tile_lock']
            ),
            ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 50.0,
          minWidth: 50.0,
          maxHeight: 50.0,
          maxWidth: 50.0,
        ), child: GestureDetector(
              onTap: (){
                _rotateFloat();
              }, child: RotatedBox(
                  quarterTurns: (_floatAngle / 90).round(),
                  child:  _floatTile
              )
          )),
          ],
        ),
      ),
    );
  }
}
