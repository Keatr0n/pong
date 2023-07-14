import 'package:flutter/material.dart';
import 'package:pong/models/game_object.dart';
import 'package:pong/models/game_state.dart';
import 'package:pong/models/hitbox.dart';
import 'package:pong/pong/score_board.dart';

class Ball extends GameObject {
  Ball();

  @override
  Hitbox calculateHitbox() {
    return Hitbox(x, y, 20, 20);
  }

  int xDirection = 1;
  int yDirection = 0;

  @override
  void init(GameState state) {
    x = state.gameBounds.width / 2 - 10;
    y = state.gameBounds.height / 2 - 10;
  }

  @override
  void destroy() {}

  @override
  void update(GameState state) {
    x += xDirection * 8;
    y += yDirection / 20;

    final collisions = state.getCollisions(this);

    if (collisions.isNotEmpty) {
      final center = collisions.first.calculateHitbox().center;

      yDirection = (yDirection + (((y + 10) - center.dy) * 5).toInt()).clamp(-100, 100);

      xDirection *= -1;
    }

    if (y < 0) {
      y = 0;
      yDirection = -yDirection;
    } else if (y > state.gameBounds.height - 20) {
      y = state.gameBounds.height - 20;
      yDirection = -yDirection;
    }

    if (x < 0) {
      x = state.gameBounds.width / 2 - 10;
      y = state.gameBounds.height / 2 - 10;
      xDirection = 1;
      yDirection = 0;
      (state.gameObjects.firstWhere((element) => element is ScoreBoard) as ScoreBoard).opponentScore++;
    } else if (x > state.gameBounds.width - 20) {
      x = state.gameBounds.width / 2 - 10;
      y = state.gameBounds.height / 2 - 10;
      xDirection = -1;
      yDirection = 0;
      (state.gameObjects.firstWhere((element) => element is ScoreBoard) as ScoreBoard).playerScore++;
    }
  }

  @override
  Widget build() {
    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: 20,
        height: 20,
        color: Colors.white,
      ),
    );
  }
}
