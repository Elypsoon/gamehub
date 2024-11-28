import 'package:flutter/material.dart';
import 'package:game_hub/screens/games/flappy_bird/components/bird.dart';
import 'package:game_hub/screens/games/flappy_bird/components/pipe_group.dart';
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
                  style: TextStyle(
                      fontSize: 20, fontFamily: 'Game', color: Colors.white),
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
                  style: TextStyle(
                      fontSize: 20, fontFamily: 'Game', color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );

  void onRestart() {
  // 1. Limpia todos los elementos activos del juego
  game.children.where((child) => child is PipeGroup || child is Bird).forEach((movable) {
    movable.removeFromParent();
  });

  // 2. Reinicia el pájaro (para restablecer su posición y puntuación)
  game.bird.reset();
  game.add(game.bird); // Vuelve a agregar el pájaro al juego

  // 3. Reinicia el temporizador para generar nuevas tuberías
  game.interval.stop(); // Detén el temporizador
  game.interval.start(); // Reinícialo con el retraso inicial

  // 4. Reactiva el motor del juego
  game.overlays.remove('gameOver'); // Elimina la pantalla de Game Over
  game.resumeEngine();

}

}
