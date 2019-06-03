import 'package:flutter/material.dart';

class BoardTile extends StatefulWidget {
  BoardTile({
    Key key,
    this.backgroundImage = Colors.blue,
    this.type,
    this.angle
  }) : super(key: key);

  final Color backgroundImage;
  final String type; // Possible values: line, corner, tee
  final int angle;
  String content = ""; // Content could be a target, a player starting or current position
  bool _movable = true;

  void setMovable(move) {
    _movable = move;
  }

  String _returnTileImagePath(type) {
    return 'assets/tile_types/$type.png';
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
    child: new RotatedBox(
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
              image: AssetImage(widget._returnTileImagePath(widget.type)))
        )
    )));
  }
}