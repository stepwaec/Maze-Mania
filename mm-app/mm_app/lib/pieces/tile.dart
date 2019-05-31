import 'package:flutter/material.dart';

class BoardTile extends StatefulWidget {

  BoardTile({Key key, this.tile, this.angle=0, this.target}) : super(key: key);

  // No separate coordinates for the tiles, they will be managed by the board
  // Assignment (fixed, float, board) should be represented differently. Fixed: board constraint, Float: coordinate [-1,-1]
  final TileDesign tile;
  int angle;          // Possible values: 0, 90, 180, 270
  final String target;      // External value from the board, value null if no target

  @override
  _BoardTileState createState() => _BoardTileState();

}

class _BoardTileState extends State<BoardTile>{

  void addTarget(target) {

  }
  void removeTarget() {

  }
  void _rotateTile() {
    setState(() {
      widget.angle = (widget.angle + 90) % 360;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: (){
          _rotateTile();
          },
        child: new RotatedBox(
          quarterTurns: (widget.angle / 90).round(),
          child: TileDesign(type:"line")
          )
    );
  }
}

class TileDesign extends StatelessWidget{
  const TileDesign({
    Key key,
    this.backgroundImage = Colors.blue,
    this.type,
  }) : super(key: key);

  final Color backgroundImage;  // Convert to image later
  final String type;            // Possible values: line, corner, cross, tee
  /* Examples at angle = 0
  line:  ||      corner: ||       cross:  ||      tee: ======
         ||              ||             ======           ||
         ||              =====            ||             ||

   */

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
        constraints: new BoxConstraints(
        minHeight: 50.0,
        minWidth: 50.0,
        maxHeight: 50.0,
        maxWidth: 50.0,
    ),
    child: new DecoratedBox(
        decoration: new BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(5.0),
          image: DecorationImage(image: AssetImage('assets/tile_types/tee.png'))
        )
    ));
  }
}