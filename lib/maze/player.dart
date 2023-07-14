import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pong/models/game_object.dart';
import 'package:pong/models/game_state.dart';
import 'package:pong/models/hitbox.dart';

class Player extends GameObject {
  Player();

  final _MovementDirection _movementDirection = _MovementDirection();

  bool _onKey(KeyEvent event) {
    _movementDirection.updateMovement(event);
    return false;
  }

  @override
  Hitbox calculateHitbox() {
    return Hitbox(x, y, 20, 20);
  }

  @override
  void init(GameState state) {
    ServicesBinding.instance.keyboard.addHandler(_onKey);
    x = state.gameBounds.width / 2 - 10;
    y = state.gameBounds.height / 2 - 10;
  }

  @override
  void destroy() {
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
  }

  @override
  void update(GameState state) {
    final movement = _movementDirection.calculateMovement();
    x += movement[0];
    y += movement[1];

    if (x < 0) {
      x = 0;
    } else if (x > state.gameBounds.width - 20) {
      x = state.gameBounds.width - 20;
    }

    if (y < 0) {
      y = 0;
    } else if (y > state.gameBounds.height - 20) {
      y = state.gameBounds.height - 20;
    }
  }

  @override
  Widget build() {
    return Positioned(
      left: x + 10,
      top: y + 10,
      child: Transform.rotate(
        angle: _movementDirection.calculateAngle(),
        child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          child: const Text(
            "▲",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class _MovementDirection {
  _MovementDirection();

  static const double moveSpeed = 4;

  bool up = false;
  bool down = false;
  bool left = false;
  bool right = false;

  double calculateAngle() {
    double result = 0;
    if (left) result += 270;
    if (right) result += 90;
    if (down) result += 180;

    if ((left || right) && (up || down)) {
      result /= 2;
    }

    if (up && left) result += 180;
    if (down && left && right) result = 180;

    return result * (pi / 180);
  }

  /// this is fucking terrible, I love it
  void updateMovement(KeyEvent event) {
    if (event is! KeyUpEvent) {
      if (event.logicalKey.keyLabel == "W") {
        up = true;
      }
      if (event.logicalKey.keyLabel == "S") {
        down = true;
      }
      if (event.logicalKey.keyLabel == "A") {
        left = true;
      }
      if (event.logicalKey.keyLabel == "D") {
        right = true;
      }
    } else {
      if (event.logicalKey.keyLabel == "W") {
        up = false;
      }
      if (event.logicalKey.keyLabel == "S") {
        down = false;
      }
      if (event.logicalKey.keyLabel == "A") {
        left = false;
      }
      if (event.logicalKey.keyLabel == "D") {
        right = false;
      }
    }
  }

  List<double> calculateMovement() {
    double x = 0;
    double y = 0;
    if (up) {
      y += -moveSpeed;
    }
    if (down) {
      y += moveSpeed;
    }
    if (left) {
      x += -moveSpeed;
    }
    if (right) {
      x += moveSpeed;
    }

    if (x != 0 && y != 0) {
      x /= 1.414;
      y /= 1.414;
    }

    return [x, y];
  }
}
