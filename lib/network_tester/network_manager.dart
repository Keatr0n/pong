import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pong/models/game_object.dart';
import 'package:pong/models/game_state.dart';
import 'package:pong/pong/pong_multiplayer_packet.dart';

class NetworkManager extends GameObject {
  NetworkManager(this.ip);

  final String ip;
  StreamSubscription? socketSubscription;
  RawDatagramSocket? socket;
  bool canWrite = false;

  List<int> previousPacket = [];

  List<int> packet = [];

  bool _onKey(KeyEvent event) {
    if (event is! KeyUpEvent) {
      packet = utf8.encode(event.logicalKey.keyLabel);
    } else {
      packet = [];
    }

    return false;
  }

  @override
  void update(GameState state) {
    if (socket != null) {
      final ipSplit = ip.split(":");

      if (canWrite) {
        final bytesSent = socket!.send(packet, InternetAddress.tryParse(ipSplit.first)!, int.parse(ipSplit.last));

        if (bytesSent == 0) {
          canWrite = false;
          Future.delayed(const Duration(milliseconds: 100), () {
            canWrite = true;
          });
        }
      }
    }
  }

  @override
  void init(GameState state) {
    createNetworkConnection();
    ServicesBinding.instance.keyboard.addHandler(_onKey);
  }

  @override
  void destroy() {
    if (socketSubscription != null) {
      socketSubscription!.cancel();
    }
  }

  @override
  Widget build() {
    return Center(
      child: Column(
        children: [
          Text("IP: $ip", style: const TextStyle(color: Colors.white)),
          Text("Last packet sent: ${utf8.decode(packet)}", style: const TextStyle(color: Colors.white)),
          Text("Packets received: ${PongGameUpdatePacket.tryFromBytes(previousPacket)}", style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  void createNetworkConnection() {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, int.parse(ip.split(":").last)).then((val) {
      socket = val;

      socketSubscription = socket!.listen((event) {
        final data = socket!.receive()?.data;
        if (data != null) {
          previousPacket = data;
        }
        if (event == RawSocketEvent.write && !canWrite) {
          canWrite = true;
        }
      });
    });
  }
}
