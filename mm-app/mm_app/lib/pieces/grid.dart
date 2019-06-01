import 'package:flutter/material.dart';
import 'package:mm_app/pieces/tile.dart';
import 'dart:math';

class GameGrid extends StatefulWidget {
  GameGrid({Key key, this.gameRules}) : super(key: key);
  final Map<String, dynamic> gameRules;

  @override
  _GameGridState createState() => _GameGridState();
}

class _GameGridState extends State<GameGrid> {

  String _typeRandomiser() {
    var seed = Random();
    int rno = seed.nextInt(3);  // There are 3 shapes
    if(rno == 0) return 'line';
    else if(rno ==1) return 'tee';
    else return 'corner';
  }
  int _angleRandomiser() {
    var seed = Random();
    int rno = seed.nextInt(4);  // There are 4 options: 0, 90, 180, 270
    return rno * 90;
  }
  void _treasureAllocator() {
  }


  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: widget.gameRules['grid_columns'],
      // Generate 100 Widgets that display their index in the List
      children: List.generate(
         widget.gameRules['grid_columns'] * widget.gameRules['grid_rows'],
              (index) {
        return Center(
          child: BoardTile(
              angle: _angleRandomiser(),
              type: _typeRandomiser(),
              treasure: null,
        )
        );
        },
    ));
  }
}