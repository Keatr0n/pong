import 'package:flutter/material.dart';
import 'package:pong/game_screen.dart';
import 'package:pong/maze/player.dart';

class Maze extends StatelessWidget {
  const Maze({super.key});

  @override
  Widget build(BuildContext context) {
    return GameScreen([
      Player(),
    ]);
  }
}
