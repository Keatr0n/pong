import 'package:flutter/material.dart';
import 'package:pong/models/game_state.dart';
import 'package:pong/models/hitbox.dart';

abstract class GameObject {
  GameObject();

  late double x;
  late double y;

  Hitbox calculateHitbox() {
    return const Hitbox(0, 0, 0, 0);
  }

  void init(GameState state) {
    x = state.gameBounds.width / 2;
    y = state.gameBounds.height / 2;
  }

  void destroy() {}
  void update(GameState state) {}

  Widget build() {
    return const Placeholder();
  }
}
