import 'package:flutter/material.dart';

enum Side { left, right, top, bottom }

class HalfClipper extends CustomClipper<Rect> {
  final Side side;
  const HalfClipper(this.side);
  @override
  Rect getClip(Size size) {
    switch (side) {
      case Side.top:
        return Rect.fromLTWH(0, 0, size.width, size.height / 2);
      case Side.bottom:
        return Rect.fromLTWH(0, size.height / 2, size.width, size.height / 2);
      case Side.left:
        return Rect.fromLTWH(0, 0, size.width / 2, size.height);
      case Side.right:
        return Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height);
    }
  }

  @override
  bool shouldReclip(HalfClipper oldClipper) => oldClipper.side != side;
}
