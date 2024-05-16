import 'dart:typed_data';

import 'package:pong/models/multiplayer_packet.dart';

class PongGameUpdatePacket extends MultiplayerPacket {
  PongGameUpdatePacket({required this.playerY, this.ballX, this.ballY});
  final double playerY;
  final double? ballX;
  final double? ballY;

  @override
  toBytes() {
    final playerYBytes = ByteData(4)..setFloat32(0, playerY);
    if (ballX == null || ballY == null) {
      return [
        0x01,
        playerYBytes.getUint8(0),
        playerYBytes.getUint8(1),
        playerYBytes.getUint8(2),
        playerYBytes.getUint8(3),
      ];
    }

    final ballXBytes = ByteData(4)..setFloat32(0, ballX!);
    final ballYBytes = ByteData(4)..setFloat32(0, ballY!);
    return [
      0x01,
      playerYBytes.getUint8(0),
      playerYBytes.getUint8(1),
      playerYBytes.getUint8(2),
      playerYBytes.getUint8(3),
      ballXBytes.getUint8(0),
      ballXBytes.getUint8(1),
      ballXBytes.getUint8(2),
      ballXBytes.getUint8(3),
      ballYBytes.getUint8(0),
      ballYBytes.getUint8(1),
      ballYBytes.getUint8(2),
      ballYBytes.getUint8(3),
    ];
  }

  factory PongGameUpdatePacket.fromBytes(List<int> bytes) {
    if (bytes[0] != 0x01 && bytes[0] != 0x02) {
      throw Exception('Invalid packet type');
    }

    final byteData = ByteData.sublistView(Uint8List.fromList(bytes.sublist(1)));

    if (bytes.length == 5) {
      return PongGameUpdatePacket(playerY: byteData.getFloat32(0));
    }

    return PongGameUpdatePacket(
      playerY: byteData.getFloat32(0),
      ballX: byteData.getFloat32(4),
      ballY: byteData.getFloat32(8),
    );
  }

  factory PongGameUpdatePacket.tryFromBytes(List<int> bytes) {
    if (bytes.isEmpty || (bytes[0] != 0x01 && bytes[0] != 0x02)) {
      return PongGameUpdatePacket(playerY: 0);
    }

    final byteData = ByteData.sublistView(Uint8List.fromList(bytes.sublist(1)));

    if (bytes.length == 5) {
      return PongGameUpdatePacket(playerY: byteData.getFloat32(0));
    }

    return PongGameUpdatePacket(
      playerY: byteData.getFloat32(0),
      ballX: byteData.getFloat32(4),
      ballY: byteData.getFloat32(8),
    );
  }

  @override
  String toString() {
    return "[player: $playerY, ballX: $ballX, ballY: $ballY]";
  }
}

class PongScorePacket extends MultiplayerPacket {
  PongScorePacket({required this.playerScore, required this.opponentScore});
  final int playerScore;
  final int opponentScore;

  @override
  toBytes() {
    return [
      0x03,
      playerScore & 0xff,
      opponentScore & 0xff,
    ];
  }

  factory PongScorePacket.fromBytes(List<int> bytes) {
    if (bytes[0] != 0x02) {
      throw Exception('Invalid packet type');
    }

    return PongScorePacket(
      playerScore: bytes[1] + (bytes[2] << 8),
      opponentScore: bytes[3] + (bytes[4] << 8),
    );
  }
}

// class PongMultiplayerPacket extends MultiplayerPacket {
//   PongMultiplayerPacket(this.playerY, this.playerScore, [this.ballX, this.ballY, this.ballXDirection, this.ballYDirection]);

//   final double playerY;
//   final double? ballX;
//   final double? ballY;
//   final int? ballXDirection;
//   final int? ballYDirection;
//   final int playerScore;

//   List<int> doubleToU8(double value) {
//     return [(value * 1000).toInt() & 0xff, ((value * 1000).toInt() >> 8) & 0xff, ((value * 1000).toInt() >> 16) & 0xff];
//   }

//   List<int> intToU8(int value) {
//     return [value & 0xff, (value >> 8) & 0xff, (value >> 16) & 0xff];
//   }

//   factory PongMultiplayerPacket.fromBytes(List<int> bytes) {
//     double doubleFromU8(List<int> value) {
//       return (value[0] + (value[1] << 8) + (value[2] << 16)) / 1000;
//     }

//     int intFromU8(List<int> value) {
//       return value[0] + (value[1] << 8) + (value[2] << 16);
//     }

//     if (bytes.length == 6) {
//       return PongMultiplayerPacket(
//         doubleFromU8(bytes.sublist(0, 3)),
//         intFromU8(bytes.sublist(3, 6)) - 1,
//       );
//     }

//     return PongMultiplayerPacket(
//       doubleFromU8(bytes.sublist(0, 3)),
//       intFromU8(bytes.sublist(3, 6)),
//       doubleFromU8(bytes.sublist(6, 9)),
//       doubleFromU8(bytes.sublist(9, 12)),
//       intFromU8(bytes.sublist(12, 15)) - 1,
//       intFromU8(bytes.sublist(15, 18)) - 100,
//     );
//   }

//   @override
//   List<int> toBytes() {
//     return [
//       ...doubleToU8(playerY),
//       ...intToU8(playerScore),
//       if (ballX != null) ...doubleToU8(ballX!),
//       if (ballY != null) ...doubleToU8(ballY!),
//       if (ballXDirection != null) ...intToU8(ballXDirection! + 1),
//       if (ballYDirection != null) ...intToU8(ballYDirection! + 100),
//     ];
//   }

//   @override
//   String toString() {
//     return 'PongMultiplayerPacket{playerY: $playerY, ballX: $ballX, ballY: $ballY, ballXDirection: $ballXDirection, ballYDirection: $ballYDirection, playerScore: $playerScore}';
//   }
// }
