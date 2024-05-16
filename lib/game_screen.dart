import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pong/models/game_object.dart';
import 'package:pong/models/game_state.dart';
import 'package:pong/models/hitbox.dart';

class GameScreen extends StatefulWidget {
  const GameScreen(this.gameObjects, {super.key});

  final List<GameObject> gameObjects;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Timer _gameLoop = Timer(Duration.zero, () {});
  late final GameState _gameState;
  bool isReady = false;

  @override
  void initState() {
    Future.microtask(() {
      _gameState = GameState(widget.gameObjects, Hitbox(0, 0, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height));
      _gameState.init();
      _gameLoop = Timer.periodic(const Duration(milliseconds: 16), (timer) {
        _gameState.update();
        if (mounted) setState(() {});
      });

      isReady = true;
    });

    super.initState();
  }

  @override
  void dispose() {
    _gameState.destroy();
    _gameLoop.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: widget.gameObjects.map((gameObject) => gameObject.build()).toList(),
      ),
    );
  }
}
