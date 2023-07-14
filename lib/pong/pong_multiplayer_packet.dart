import 'package:pong/models/multiplayer_packet.dart';

class PongMultiplayerPacket extends MultiplayerPacket {
  PongMultiplayerPacket(this.playerY, this.playerScore, [this.ballX, this.ballY, this.ballXDirection, this.ballYDirection]);

  final double playerY;
  final double? ballX;
  final double? ballY;
  final int? ballXDirection;
  final int? ballYDirection;
  final int playerScore;

  List<int> doubleToU8(double value) {
    return [(value * 1000).toInt() & 0xff, ((value * 1000).toInt() >> 8) & 0xff, ((value * 1000).toInt() >> 16) & 0xff];
  }

  List<int> intToU8(int value) {
    return [value & 0xff, (value >> 8) & 0xff, (value >> 16) & 0xff];
  }

  factory PongMultiplayerPacket.fromBytes(List<int> bytes) {
    double doubleFromU8(List<int> value) {
      return (value[0] + (value[1] << 8) + (value[2] << 16)) / 1000;
    }

    int intFromU8(List<int> value) {
      return value[0] + (value[1] << 8) + (value[2] << 16);
    }

    if (bytes.length == 6) {
      return PongMultiplayerPacket(
        doubleFromU8(bytes.sublist(0, 3)),
        intFromU8(bytes.sublist(3, 6)) - 1,
      );
    }

    return PongMultiplayerPacket(
      doubleFromU8(bytes.sublist(0, 3)),
      intFromU8(bytes.sublist(3, 6)),
      doubleFromU8(bytes.sublist(6, 9)),
      doubleFromU8(bytes.sublist(9, 12)),
      intFromU8(bytes.sublist(12, 15)) - 1,
      intFromU8(bytes.sublist(15, 18)) - 100,
    );
  }

  @override
  List<int> toBytes() {
    return [
      ...doubleToU8(playerY),
      ...intToU8(playerScore),
      if (ballX != null) ...doubleToU8(ballX!),
      if (ballY != null) ...doubleToU8(ballY!),
      if (ballXDirection != null) ...intToU8(ballXDirection! + 1),
      if (ballYDirection != null) ...intToU8(ballYDirection! + 100),
    ];
  }

  @override
  String toString() {
    return 'PongMultiplayerPacket{playerY: $playerY, ballX: $ballX, ballY: $ballY, ballXDirection: $ballXDirection, ballYDirection: $ballYDirection, playerScore: $playerScore}';
  }
}
