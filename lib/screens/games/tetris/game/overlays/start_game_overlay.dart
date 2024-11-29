import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:game_hub/screens/games/tetris/game/tetris_game.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StartGameOverlay extends StatelessWidget {
  static String keyOverlay = "startGameOverlay";
  final TetrisGame game;

  const StartGameOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                game.startCountDown(
                  key: keyOverlay,
                );
              },
              child: Column(
                children: [
                  const Icon(
                    Icons.play_arrow,
                    size: 100,
                    color: Colors.black,
                  ),
                  Text(
                    "Iniciar",
                    style: GoogleFonts.getFont(
                      'Chakra Petch',
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                game.exitGame();
                Get.toNamed('/games'); // Salir o regresar al menú
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // Color del botón
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              child: Text(
                "Salir",
                style: GoogleFonts.getFont(
                  'Chakra Petch',
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}