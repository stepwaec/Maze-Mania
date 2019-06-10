import 'package:flutter/material.dart';

class BoardTile extends StatefulWidget {
  BoardTile({
    Key key,
    this.backgroundImage = Colors.blue,
    this.type,
    this.angle,
    this.target
  }) : super(key: key);

  final Color backgroundImage;
  final String type; // Possible values: line, corner, tee
  int angle;
  String target; // Content could be a target, a player starting or current position
  int _playerId;
  int _startingPositionId;
  Color _startingPositionColor;
  bool _movable = true;

  void setMovable(move) {
    _movable = move;  // Need to use a const file to store colours etc.
  }

  void setPlayer(playerId) {
    _playerId = playerId;
  }

  void setStartingPosition(playerId, playerColour) {
    _playerId = playerId;
    _startingPositionId = playerId;
    _startingPositionColor = playerColour;
  }

  String _getTargetPath(targetId) {
    return 'assets/targets/$targetId';
  }

  String _getTileImagePath(type) {
    return 'assets/tile_types/$type.png';
  }

  List<bool> getMoveOptions() { // up, right, down, left
    /*
    default: corner['left','up'], line['up','down'], tee['left','up', 'right']
     */
    Map<String, List<bool>> typeOptions = {
    'corner': [true, false, false, true],
    'line': [true, false, true, false],
    'tee': [true, true, false, true]
    };
    return _shiftList(typeOptions[this.type], (this.angle/90).round());
  }

  List<bool> _shiftList (list, offset){
    List<bool> moveOptions = [false, false, false, false];
    for(int i=0, j=(i-offset)%4; i < 4; i++,j=(j+1)%4){
      moveOptions[i] = list[j];
    }
    return moveOptions;
  }

  @override
    _BoardTileState createState() => _BoardTileState();

}

class _BoardTileState extends State<BoardTile> {

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
        minHeight: 50.0,
        minWidth: 50.0,
        maxHeight: 50.0,
        maxWidth: 50.0,
    ),
    child: new Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        new Positioned(
            left: 0.0, right: 0.0, bottom: 0.0, top: 0.0,
            child:RotatedBox(
            quarterTurns: (widget.angle / 90).round(),
            child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.lightBlue[50],
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        width: (!widget._movable)
                            ? 2
                            : 0,
                        color: Colors.black),
                    image: DecorationImage(
                        image: AssetImage(widget._getTileImagePath(widget.type)))
                )
            ))),
        (widget.target != null)
            ? new Positioned(
                child: Container(
                  margin: EdgeInsets.all(2.5),
                  width: 14.0,
                  height: 14.0,
                  decoration: new BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(widget._getTargetPath(widget.target))
                    )
                  ),
                ),
              )
            : new Container(width: 0, height: 0),
        (widget._startingPositionId != null)
            ? new Positioned(
            left: 12.5,  top: 12.5,
            child: Container(
              height: 25.0,
              width: 25.0,
              decoration: new BoxDecoration(
                  color: widget._startingPositionColor,
                  shape: BoxShape.circle,
              )
            )
        )
            : new Container(width: 0, height: 0),
        (widget._playerId != null)
            ? new Positioned(
            left: 17.0,  top: 17.0,
            child: Text("P"+(widget._playerId+1).toString()),
            )
            : new Container(width: 0, height: 0)
      ],
    ),);
  }
}