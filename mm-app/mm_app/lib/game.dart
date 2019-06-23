import 'package:flutter/material.dart';
import 'pieces/tile.dart';
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
  Player currentPlayer;


  @override
  void initState(){
    super.initState();
    _floatTile = widget.gameTiles.removeLast();
    _floatAngle = 0;
    _blockTiles(widget.gameRules['tile_lock']);
    for(int i = 0; i<widget.players.length; i++){ // Set position of players
      _setStartingTile(widget.players[i]);
    }
    currentPlayer = widget.players[2]; // TODO: make this dynamic with round data
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
  void _setStartingTile(player){  // Sequentially invoked, assumes max_number is checked
    /*
    PATTERN:   P1 - P7 - P4
               -  - -  - -
               P5 - -  - P6
               -  - -  - -
               P3 - P8 - P2

     */
    int target;
    switch (player.playerId-1) {    // Players are given ids starting from 1
      case 0: // First tile
        target = 0;
        break;
      case 1: // Last tile
        target = widget.gameTiles.length-1;
        break;
      case 2: // Beginning of last row
        target = widget.gameTiles.length - widget.gameRules['grid_columns'];;
        break;
      case 3: // End of first row
        target = widget.gameRules['grid_columns']-1;
        break;
      case 4: // Beginning of middle row
        target = (widget.gameRules['grid_rows']/2 - 1).round() * widget.gameRules['grid_columns'];
        break;
      case 5: // End of middle row
        target =  (widget.gameRules['grid_rows']/2).round() * widget.gameRules['grid_columns'] - 1;
        break;
      case 6: // Middle of first row
        target = (widget.gameRules['grid_columns']/2 - 1).round();
        break;
      case 7: // Middle of last row
        target = widget.gameTiles.length - (widget.gameRules['grid_columns']/2).round();
        break;
    }
    widget.gameTiles[target].setStartingPosition(player);
    player.setPlayerPosition(widget.gameTiles[target]);
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
                    Inserter(type: type, side: side, index: _getRCIndex(index),)
                ),)
          ));
        },)
    );
    }
    else
      return null;
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
    return row * widget.gameRules['grid_columns'] + column;
  }

  List<BoardTile> _getPossibleRelativeTiles(currentTile){
    List<BoardTile> options = [];
    List<bool> directionsAllowed = currentTile.getMoveOptions(); // Up, right, down, left
    int indexPosition = widget.gameTiles.indexOf(currentTile);
    BoardTile _tileAbove, _tileRight, _tileBelow, _tileLeft;

    if(directionsAllowed[0] && indexPosition - widget.gameRules['grid_columns'] > 0) { // Check UP AND NOT top row
      _tileAbove = widget.gameTiles[indexPosition - widget.gameRules['grid_columns']];
      if(_tileAbove.getMoveOptions()[2]) {  // If tile above can also accept down
        options.add(_tileAbove);
      }
    }
    if(directionsAllowed[1] && (indexPosition + 1) % widget.gameRules['grid_columns'] != 0){ // Check Right AND NOT right column
      _tileRight = widget.gameTiles[indexPosition + 1];
      if(_tileRight.getMoveOptions()[3]) { // If right tile can also accept left
        options.add(_tileRight);
      }
    }
    if(directionsAllowed[2] && indexPosition + widget.gameRules['grid_columns'] < widget.gameTiles.length){ // Check Down AND NOT bottom row
      _tileBelow = widget.gameTiles[indexPosition + widget.gameRules['grid_columns']];
      if(_tileBelow.getMoveOptions()[0]) {  // If tile below can also accept up
        options.add(_tileBelow);
      }
    }
    if(directionsAllowed[3] && (indexPosition-1) % widget.gameRules['grid_columns'] != widget.gameRules['grid_columns'] - 1){ // Left...
      _tileLeft = widget.gameTiles[indexPosition - 1];
      if(_tileLeft.getMoveOptions()[1]) { // ...
        options.add(_tileLeft);
      }
    }
    return options;
  }

  // PLAY FUNCTIONS
  void _transferFloat(type, side, index ) {
    setState(() {
      BoardTile newFloat;
      if(type == 'row' && side == 'start') {
        newFloat = widget.gameTiles[_getTileIndex(index, widget.gameRules['grid_columns'] - 1)];
        widget.gameTiles.removeAt(_getTileIndex(index, widget.gameRules['grid_columns'] - 1));
        widget.gameTiles.insert(_getTileIndex(index, 0), _floatTile);
        _floatTile = newFloat;
      } else if(type == 'row' && side == 'end') {
        newFloat = widget.gameTiles[_getTileIndex(index, 0)];
        widget.gameTiles.removeAt(_getTileIndex(index, 0));
        widget.gameTiles.insert(_getTileIndex(index, widget.gameRules['grid_columns'] - 1), _floatTile);
        _floatTile = newFloat;
      } else if(type == 'column' && side == 'start') {
        newFloat = widget.gameTiles[_getTileIndex(widget.gameRules['grid_rows'] - 1, index)];
        for (int i = _getTileIndex(widget.gameRules['grid_rows']-1, index);
              i >= widget.gameRules['grid_columns'];
              i -= widget.gameRules['grid_columns']) {
          widget.gameTiles[i] = widget.gameTiles[i - widget.gameRules['grid_columns']];
        }
        widget.gameTiles[index] = _floatTile;
        _floatTile = newFloat;
      } else { // row, end
          newFloat = widget.gameTiles[index];
          for (int i = index;
                i <= widget.gameTiles.length - widget.gameRules['grid_columns'];
                i += widget.gameRules['grid_columns']) {
            widget.gameTiles[i] = widget.gameTiles[i + widget.gameRules['grid_columns']];
          }
          widget.gameTiles[_getTileIndex(widget.gameRules['grid_rows']-1, index)] = _floatTile;
          _floatTile = newFloat;
      }
    });
  }

  void _rotateFloat() {
    setState(() {
      _floatAngle = (_floatAngle + 90) % 360;
      _floatTile.angle = (_floatTile.angle + 90) % 360;
      print(_floatTile.getMoveOptions().toString());
    });
  }

  void _movePlayer(BoardTile newPosition){
    setState((){
      BoardTile _currentTile = currentPlayer.getPlayerPosition();
      if (_currentTile == _floatTile){
        print("CANNOT MOVE, you are on the float");
      }
      else {
        List<BoardTile> options = _getPossibleRelativeTiles(_currentTile);
        if(options.contains(newPosition)){
          print("${currentPlayer.name} can move there");
            _currentTile.setPlayer(null);
            newPosition.setPlayer(currentPlayer);
            currentPlayer.setPlayerPosition(newPosition);;
            print("${currentPlayer.name} has moved.");
        } else {
          print("${currentPlayer.name} CANNOT move there");
        }
      }
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
              GridView.count(
                  crossAxisCount: widget.gameRules['grid_columns'],
                  children: List.generate(
                    widget.gameTiles.length,
                        (index) {
                      return GestureDetector(
                          onTap: () =>  _movePlayer(widget.gameTiles[index]),
                          child: widget.gameTiles[index]
                      );
                    },
                  )),
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
                )
            ),
          ],
        ),
      ),
    );
  }
}
