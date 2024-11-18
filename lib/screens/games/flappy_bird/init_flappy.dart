import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_hub/screens/games/flappy_bird/game/flappy_bird_game.dart';
import 'package:game_hub/screens/games/flappy_bird/screens/main_menu_screen.dart';
import 'screens/game_over_screen.dart';

// Clase que inicializa el juego FlappyBird
class InitFlappyBird extends StatelessWidget {
  const InitFlappyBird({super.key});

  @override
  Widget build(BuildContext context) {
    final game = FlappyBirdGame();  // Instancia del juego

    return Scaffold(
      body: GameWidget(
        game: game,
        initialActiveOverlays: const [MainMenuScreen.id],
        overlayBuilderMap: {
        'mainMenu': (context, _) => MainMenuScreen(game: game),
        'gameOver': (context, _) => GameOverScreen(game: game),
        },
      ),
    );
  }
}
