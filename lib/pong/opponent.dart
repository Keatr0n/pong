import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pong/models/game_object.dart';
import 'package:pong/models/hitbox.dart';
import 'package:pong/models/game_state.dart';
import 'package:pong/pong/ball.dart';

class Opponent extends GameObject {
  Opponent();
  int score = 0;

  @override
  Hitbox calculateHitbox() {
    return Hitbox(x, y, 20, 100);
  }

  @override
  void init(GameState state) {
    y = state.gameBounds.height / 2 - 50;
    x = state.gameBounds.width - 40;
  }

  @override
  void update(GameState state) {
    final ball = state.gameObjects.firstWhere((element) => element is Ball) as Ball;
    final ballHitbox = ball.calculateHitbox();
    final ballCenter = ballHitbox.center;

    if (ball.xDirection == 1 && ball.yDirection.abs() > 50) {
      if (ball.yDirection < 0) {
        y -= 4;
      } else {
        y += 4;
      }
    } else if ((ballCenter.dy - (y + 50)).abs() > 25) {
      if (ballCenter.dy > y + 50) {
        y += 4;
      } else {
        y -= 4;
      }
    }

    if (y + 100 > state.gameBounds.height) {
      y = state.gameBounds.height - 100;
    } else if (y < 0) {
      y = 0;
    }
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
