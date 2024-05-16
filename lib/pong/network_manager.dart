import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pong/models/game_object.dart';
import 'package:pong/models/game_state.dart';
import 'package:pong/pong/ball.dart';
import 'package:pong/pong/player.dart';
import 'package:pong/pong/player_2.dart';
import 'package:pong/pong/pong_multiplayer_packet.dart';
import 'package:pong/pong/score_board.dart';

class NetworkManager extends GameObject {
  NetworkManager(this.ip, this.isHost, [this.listenPort]);

  Timer scoreLoop = Timer(Duration.zero, () {});

  final String ip;
  final int? listenPort;
  final bool isHost;
  StreamSubscription? socketSubscription;
  RawDatagramSocket? socket;
  PongGameUpdatePacket? lastPacket;
  bool sendScore = false;

  @override
  void update(GameState state) {
    if (socket != null) {
      final ipSplit = ip.split(":");
      final newPacket = isHost
          ? PongGameUpdatePacket(
              playerY: (state.gameObjects.firstWhere((element) => element is Player) as Player).y / state.gameBounds.height,
              ballX: (((state.gameObjects.firstWhere((element) => element is Ball) as Ball).x / state.gameBounds.width) * -1) + 1,
              ballY: (state.gameObjects.firstWhere((element) => element is Ball) as Ball).y / state.gameBounds.height,
              // (state.gameObjects.firstWhere((element) => element is Ball) as Ball).xDirection,
              // (state.gameObjects.firstWhere((element) => element is Ball) as Ball).yDirection,
              // (state.gameObjects.firstWhere((element) => element is ScoreBoard) as ScoreBoard).playerScore,
            )
          : PongGameUpdatePacket(
              playerY: (state.gameObjects.firstWhere((element) => element is Player) as Player).y / state.gameBounds.height,
              // (state.gameObjects.firstWhere((element) => element is ScoreBoard) as ScoreBoard).playerScore,
            );

      try {
        if (sendScore && isHost) {
          sendScore = false;
          socket!.send(
            PongScorePacket(
              playerScore: (state.gameObjects.firstWhere((element) => element is ScoreBoard) as ScoreBoard).playerScore,
              opponentScore: (state.gameObjects.firstWhere((element) => element is ScoreBoard) as ScoreBoard).opponentScore,
            ).toBytes(),
            InternetAddress.tryParse(ipSplit.first)!,
            int.parse(ipSplit.last),
          );
        } else if (!isHost) {
          sendScore = false;
          scoreLoop.cancel();
        }

        socket!.send(newPacket.toBytes(), InternetAddress.tryParse(ipSplit.first)!, int.parse(ipSplit.last));
      } catch (e) {
        print(e);
      }
    }

    if (lastPacket != null) {
      (state.gameObjects.firstWhere((element) => element is Player2) as Player2).nextLocation = lastPacket!.playerY * state.gameBounds.height;
      // (state.gameObjects.firstWhere((element) => element is ScoreBoard) as ScoreBoard).opponentScore = lastPacket!.playerScore;
      if (!isHost) {
        (state.gameObjects.firstWhere((element) => element is Ball) as Ball).x = lastPacket!.ballX! * state.gameBounds.width;
        (state.gameObjects.firstWhere((element) => element is Ball) as Ball).y = lastPacket!.ballY! * state.gameBounds.height;
        // (state.gameObjects.firstWhere((element) => element is Ball) as Ball).xDirection = lastPacket!.ballXDirection! * -1;
        // (state.gameObjects.firstWhere((element) => element is Ball) as Ball).yDirection = lastPacket!.ballYDirection! * -1;
      }
    }
  }

  @override
  void init(GameState state) {
    createNetworkConnection();
  }

  @override
  void destroy() {
    if (socketSubscription != null) {
      socketSubscription!.cancel();
    }
  }

  @override
  Widget build() {
    return Container();
  }

  void createNetworkConnection() {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, int.parse(ip.split(":").last)).then((val) {
      socket = val;

      scoreLoop = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        sendScore = true;
      });

      socketSubscription = socket!.listen((event) {
        final data = socket!.receive()?.data;
        if (data != null) {
          lastPacket = PongGameUpdatePacket.fromBytes(data);
        }
      });
    });
  }
}
