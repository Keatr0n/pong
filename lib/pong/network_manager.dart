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

  final String ip;
  final int? listenPort;
  final bool isHost;
  StreamSubscription? socketSubscription;
  RawDatagramSocket? socket;
  PongMultiplayerPacket? lastPacket;
  bool canWrite = false;

  @override
  void update(GameState state) {
    if (socket != null) {
      final ipSplit = ip.split(":");
      final newPacket = isHost
          ? PongMultiplayerPacket(
              (state.gameObjects.firstWhere((element) => element is Player) as Player).y,
              (state.gameObjects.firstWhere((element) => element is ScoreBoard) as ScoreBoard).playerScore,
              (state.gameObjects.firstWhere((element) => element is Ball) as Ball).x,
              (state.gameObjects.firstWhere((element) => element is Ball) as Ball).y,
              (state.gameObjects.firstWhere((element) => element is Ball) as Ball).xDirection,
              (state.gameObjects.firstWhere((element) => element is Ball) as Ball).yDirection,
            )
          : PongMultiplayerPacket(
              (state.gameObjects.firstWhere((element) => element is Player) as Player).y,
              (state.gameObjects.firstWhere((element) => element is ScoreBoard) as ScoreBoard).playerScore,
            );

      if (canWrite) {
        final bytesSent = socket!.send(newPacket.toBytes(), InternetAddress.tryParse(ipSplit.first)!, int.parse(ipSplit.last));

        if (bytesSent == 0) {
          canWrite = false;

          Future.delayed(Duration(milliseconds: isHost ? 1 : 250), () {
            createNetworkConnection();
          });
        }
      }
    }

    if (lastPacket != null) {
      (state.gameObjects.firstWhere((element) => element is Player2) as Player2).nextLocation = lastPacket!.playerY;
      (state.gameObjects.firstWhere((element) => element is ScoreBoard) as ScoreBoard).opponentScore = lastPacket!.playerScore;
      if (!isHost) {
        (state.gameObjects.firstWhere((element) => element is Ball) as Ball).x = ((lastPacket!.ballX! - (state.gameBounds.width / 2)) * -1) + (state.gameBounds.width / 2);
        (state.gameObjects.firstWhere((element) => element is Ball) as Ball).y = lastPacket!.ballY!;
        (state.gameObjects.firstWhere((element) => element is Ball) as Ball).xDirection = lastPacket!.ballXDirection! * -1;
        (state.gameObjects.firstWhere((element) => element is Ball) as Ball).yDirection = lastPacket!.ballYDirection! * -1;
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
    RawDatagramSocket.bind(InternetAddress.anyIPv4, listenPort ?? int.parse(ip.split(":").last)).then((val) {
      socket = val;

      socketSubscription = socket!.listen((event) {
        final data = socket!.receive()?.data;
        if (data != null) {
          lastPacket = PongMultiplayerPacket.fromBytes(data);
          if (isHost) {
            canWrite = true;
          }
        }
        if (event == RawSocketEvent.write && !canWrite && !isHost) {
          canWrite = true;
        }
      });
    });
  }
}
