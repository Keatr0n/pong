import 'package:flutter/material.dart';
import 'package:pong/game_screen.dart';
import 'package:pong/network_tester/network_manager.dart';

class NetworkTester extends StatefulWidget {
  const NetworkTester({super.key});

  @override
  State<NetworkTester> createState() => _NetworkTesterState();
}

class _NetworkTesterState extends State<NetworkTester> {
  bool startedServer = false;

  TextEditingController ipController = TextEditingController();
  TextEditingController listenPortController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (startedServer) {
      return GameScreen([
        NetworkManager(ipController.text),
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
                  startedServer = true;
                });
              },
              child: const Text(
                "Start Server",
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
          ],
        ),
      ),
    );
  }
}
