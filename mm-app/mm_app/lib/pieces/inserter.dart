import 'package:flutter/material.dart';

class Inserter extends StatelessWidget{
  Inserter({
    Key key,
    this.index,
    this.type,
    this.side
  }) : super(key: key);

  final Color colour = Colors.green;
  final int index;          // column or row number (starting zero)
  final String type;       // 'column' or 'row'
  final String side;      // Can be 'start' or 'end'

  CustomClipper _getTriangle() {
    if (this.side == 'start' && this.type == "row") {
      return StartRowTriangle();
    } else if (this.side == 'end' && this.type == "row") {
      return EndRowTriangle();
    } else if (this.side == 'start' && this.type == "column") {
      return StartColumnTriangle();
    } else if (this.side == 'end' && this.type == "column") {
      return EndColumnTriangle();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        color: this.colour,
      ),
      clipper: _getTriangle()
    );
  }
}

class StartColumnTriangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(StartColumnTriangle oldClipper) => true;
}

class EndColumnTriangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width / 2, 0.0);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(EndColumnTriangle oldClipper) => false;
}

class StartRowTriangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(StartRowTriangle oldClipper) => false;
}

class EndRowTriangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height / 2);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.lineTo(0.0, size.height / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(EndRowTriangle oldClipper) => false;
}