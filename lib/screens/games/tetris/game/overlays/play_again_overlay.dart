import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:game_hub/screens/games/tetris/game/tetris_game.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayAgainOverlay extends StatelessWidget {
  static String keyOverlay = "playAgainOverlay";

  final TetrisGame game;
  const PlayAgainOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
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
                    "Volver a jugar",
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
                Get.offAllNamed('/games'); // Salir o regresar al menú
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // Color del botón
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              child: Text(
                "Exit",
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
