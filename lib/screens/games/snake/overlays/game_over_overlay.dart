import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_hub/screens/games/snake/snake_game.dart';
import 'package:get/get.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay(this.game, {super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Card(
                color: const Color.fromARGB(180, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  //set border radius more than 50% of height and width to make circle
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          'Game Over',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          (game as SnakeGame).playAgain();
                        },
                        style: ButtonStyle(
                          minimumSize: WidgetStateProperty.all(
                            const Size(150, 60),
                          ),
                          textStyle: WidgetStateProperty.all(
                              Theme.of(context).textTheme.titleLarge),
                        ),
                        child: const Text('Reintentar'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Regresa al menú y asegura que el juego se reconstruya
                          Get.offAllNamed('/games');
                        },
                        style: ButtonStyle(
                          minimumSize: WidgetStateProperty.all(
                            const Size(150, 60),
                          ),
                          textStyle: WidgetStateProperty.all(
                              Theme.of(context).textTheme.titleLarge),
                        ),
                        child: const Text('Salir'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
