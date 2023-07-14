import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pong/models/game_object.dart';
import 'package:pong/models/game_state.dart';
import 'package:pong/models/hitbox.dart';

class Player extends GameObject {
  Player();

  int moveDirection = 0;

  bool _onKey(KeyEvent event) {
    if (event is! KeyUpEvent) {
      if (event.logicalKey.keyLabel == "W") {
        moveDirection = -1;
      } else if (event.logicalKey.keyLabel == "S") {
        moveDirection = 1;
      }
    } else {
      moveDirection = 0;
    }
    return false;
  }

  @override
  Hitbox calculateHitbox() {
    return Hitbox(x, y, 20, 100);
  }

  @override
  void update(GameState state) {
    y += moveDirection * 4;

    if (y < 0) {
      y = 0;
    } else if (y > state.gameBounds.height - 100) {
      y = state.gameBounds.height - 100;
    }
  }

  @override
  void init(GameState state) {
    ServicesBinding.instance.keyboard.addHandler(_onKey);
    y = state.gameBounds.height / 2 - 50;
    x = 20;
  }

  @override
  void destroy() {
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
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
