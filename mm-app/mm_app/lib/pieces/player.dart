import 'package:flutter/material.dart';

class Player extends StatelessWidget{
  const Player({
    Key key,
    this.colour,
    this.name,
    this.treasureIds
  }) : super(key: key);

  final Color colour;
  final String name;
  final List<String> treasureIds;

  @override
  Widget build(BuildContext context) {
    return Text(name);
  }
}