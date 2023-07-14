import 'package:flutter/material.dart';
import 'package:pong/models/game_object.dart';
import 'package:pong/models/game_state.dart';
import 'package:pong/models/hitbox.dart';

class Player2 extends GameObject {
  Player2();

  double nextLocation = 0;

  @override
  Hitbox calculateHitbox() {
    return Hitbox(x, y, 20, 100);
  }

  @override
  void update(GameState state) {
    y = nextLocation;

    if (y < 0) {
      y = 0;
    } else if (y > state.gameBounds.height - 100) {
      y = state.gameBounds.height - 100;
    }
  }

  @override
  void init(GameState state) {
    y = state.gameBounds.height / 2 - 50;
    nextLocation = y;
    x = state.gameBounds.width - 40;
  }

  @override
  Widget build() {
    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: 20,
        height: 100,
        color: Colors.white,
      ),
    );
  }
}
