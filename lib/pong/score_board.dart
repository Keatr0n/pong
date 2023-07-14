import 'package:flutter/material.dart';
import 'package:pong/models/game_object.dart';
import 'package:pong/models/game_state.dart';

class ScoreBoard extends GameObject {
  int opponentScore = 0;
  int playerScore = 0;

  @override
  void init(GameState state) {
    x = state.gameBounds.width / 2 - 100;
    y = 10;
  }

  @override
  Widget build() {
    return Positioned(
      left: x,
      top: y,
      child: SizedBox(
        width: 200,
        height: 100,
        child: Center(
          child: Text(
            '$playerScore - $opponentScore',
            style: const TextStyle(
              fontSize: 40,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
