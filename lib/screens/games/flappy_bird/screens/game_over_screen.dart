import 'package:flutter/material.dart';
import 'package:game_hub/screens/games/flappy_bird/game/assets.dart';
import 'package:game_hub/screens/games/flappy_bird/game/flappy_bird_game.dart';

//Pantalla que se muestra cuando el juego termina
class GameOverScreen extends StatelessWidget {
  final FlappyBirdGame game;

  const GameOverScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.black38,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Puntuación: ${game.bird.score}',
                style: const TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  fontFamily: 'Game',
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(Assets.gameOver),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onRestart,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text(
                  'Reiniciar',
                  style: TextStyle(fontSize: 20, fontFamily: 'Game', color: Colors.white),
                ),
              ),
              //Botón para regresar al menú principal
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text(
                  'Salir',
                  style: TextStyle(fontSize: 20, fontFamily: 'Game', color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );

  void onRestart() {
    game.bird.reset();
    game.overlays.remove('gameOver');
    game.resumeEngine();
  }
}