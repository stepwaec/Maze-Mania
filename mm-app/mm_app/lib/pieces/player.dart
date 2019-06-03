import 'package:flutter/material.dart';

class Player extends StatelessWidget{
  Player({
    Key key,
    this.colour,
    this.name,
    this.targetIds
  }) : super(key: key);

  final Color colour;
  final String name;
  final List<String> targetIds;
  int position = 0; // Position is relative to array of tiles

  @override
  Widget build(BuildContext context) {
    return Text(name);
  }
}