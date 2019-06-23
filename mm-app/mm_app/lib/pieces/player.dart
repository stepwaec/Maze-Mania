import 'package:flutter/material.dart';
import 'package:mm_app/pieces/tile.dart';

class Player extends StatefulWidget { // TODO: Can I revert it back to Stateless?
  Player({
    Key key,
    this.playerId,
    this.colour,
    this.name,
    this.targetIds
  }) : super(key: key);

  final int playerId;
  final Color colour;
  final String name;
  final List<String> targetIds;
  BoardTile _currentTile;

  void setPlayerPosition(newTile){
    _currentTile = newTile;
  }
//
//  Widget getPlayerToken(){
//    return Text(this.name);
//  }

  BoardTile getPlayerPosition(){
    return _currentTile;
  }

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {

  @override
  Widget build(BuildContext context) {
    return Text(widget.name);
  }
}