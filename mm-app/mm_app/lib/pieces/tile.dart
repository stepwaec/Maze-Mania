import 'package:flutter/material.dart';

class BoardTile extends StatelessWidget{
  const BoardTile({
    Key key,
    this.backgroundImage = Colors.blue,
    this.type,
    this.angle,
    this.treasure
  }) : super(key: key);

  final Color backgroundImage;
  final String type;            // Possible values: line, corner, tee
  final int angle;
  final String treasure;
  /* Examples at angle = 0
  line:  ||      corner: ||       cross:  ||      tee: ====== // NO CROSS
         ||              ||             ======           ||
         ||              =====            ||             ||

   */

  String _returnTileImagePath(type) {
    return 'assets/tile_types/$type.png';
  }
  
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
      quarterTurns: (angle / 90).round(),
        child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.lightBlue[50],
          borderRadius: BorderRadius.circular(5.0),
          image: DecorationImage(
              image: AssetImage(_returnTileImagePath(type)))
        )
    )));
  }
}