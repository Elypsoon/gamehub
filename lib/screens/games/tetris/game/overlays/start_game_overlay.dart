import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:game_hub/screens/games/tetris/game/tetris_game.dart';
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
          child: InkWell(
              onTap: () {
                game.startCountDown(
                  key: keyOverlay,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.play_arrow,
                    size: 100,
                    color: Colors.black,
                  ),
                  Text(
                    "Start Game",
                    style: GoogleFonts.getFont(
                      'Chakra Petch',
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}
