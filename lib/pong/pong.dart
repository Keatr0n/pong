import 'package:flutter/material.dart';
import 'package:pong/game_screen.dart';
import 'package:pong/pong/ball.dart';
import 'package:pong/pong/network_manager.dart';
import 'package:pong/pong/opponent.dart';
import 'package:pong/pong/player.dart';
import 'package:pong/pong/player_2.dart';
import 'package:pong/pong/score_board.dart';

class Pong extends StatefulWidget {
  const Pong({super.key});

  @override
  State<Pong> createState() => _PongState();
}

class _PongState extends State<Pong> {
  bool isMultiplayer = false;
  bool gameStarted = false;
  bool isHosting = false;

  TextEditingController ipController = TextEditingController();
  TextEditingController listenPortController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (gameStarted) {
      return GameScreen([
        if (isMultiplayer) NetworkManager(ipController.text, isHosting),
        Player(),
        Ball(),
        isMultiplayer ? Player2() : Opponent(),
        ScoreBoard(),
      ]);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  gameStarted = true;
                });
              },
              child: const Text(
                'Single Player',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  isMultiplayer = true;
                  gameStarted = true;
                  isHosting = true;
                });
              },
              child: const Text(
                "Host game",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  isMultiplayer = true;
                  gameStarted = true;
                  isHosting = false;
                });
              },
              child: const Text(
                "Join game",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: TextField(
                controller: ipController,
                decoration: const InputDecoration(
                  hintText: 'Enter IP address (with port)',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            // SizedBox(
            //   width: 50,
            //   child: TextField(
            //     controller: listenPortController,
            //     decoration: const InputDecoration(
            //       hintText: 'Listen port',
            //       hintStyle: TextStyle(
            //         color: Colors.white,
            //       ),
            //     ),
            //     style: const TextStyle(
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
