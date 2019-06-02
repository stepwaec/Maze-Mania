import 'package:flutter/material.dart';
import 'package:mm_app/pieces/tile.dart';

class GameGrid extends StatefulWidget {
  GameGrid({Key key, this.gameRules, this.gameTiles}) : super(key: key);
  final Map<String, dynamic> gameRules;
  final List<BoardTile> gameTiles;

  @override
  _GameGridState createState() => _GameGridState();
}

class _GameGridState extends State<GameGrid> {

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: widget.gameRules['grid_columns'],
      children: List.generate(
         widget.gameTiles.length,
              (index) {
        return Center(
          child: widget.gameTiles[index]
        );
        },
    ));
  }
}