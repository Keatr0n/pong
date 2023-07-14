import 'package:flutter/material.dart';

class Hitbox {
  const Hitbox(this.x, this.y, this.width, this.height);

  final double x;
  final double y;
  final double width;
  final double height;

  bool collidesWith(Hitbox other) {
    return x < other.x + other.width && x + width > other.x && y < other.y + other.height && y + height > other.y;
  }

  Offset get center => Offset(x - (width / 2), y + (height / 2));
}
