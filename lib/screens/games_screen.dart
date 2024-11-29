import 'package:flutter/material.dart';
import 'package:game_hub/screens/games/dino_run/init_dino.dart';
import 'package:game_hub/screens/games/flappy_bird/init_flappy_bird.dart';
import 'package:game_hub/screens/games/snake/init_snake.dart';
import 'package:game_hub/screens/games/tetris/init_tetris.dart';
import 'package:get/get.dart';
import 'package:zhi_starry_sky/starry_sky.dart';

class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de juegos
    final games = [
      {'name': 'Flappy Bird', 'image': 'assets/images/flappyBird.png', 'init': () => const InitFlappyBird()},
      {'name': 'Dino Run', 'image': 'assets/images/dino-run.jpg', 'init': () => const InitDinoRun()},
      {'name': 'Tetris', 'image': 'assets/images/tetris.png', 'init': () => const InitTetris()},
      {'name': 'Snake', 'image': 'assets/images/snake.png', 'init': () => InitSnake()},
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Fondo animado
          const Positioned.fill(
            child: Center(
              child: StarrySkyView(),
            ),
          ),
          // Contenido principal
          SafeArea(
            child: Column(
              children: [
                // Botón de regreso y título
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botón de regreso
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Get.toNamed('/');
                        },
                      ),
                      const Text(
                        'Selecciona un juego',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(2, 2),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48), // Espaciado para centrar el título
                    ],
                  ),
                ),
                // Lista de juegos
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: games.map((game) {
                        return GestureDetector(
                          onTap: () {
                            // Lógica para iniciar el juego
                            Get.snackbar(
                              'Juego seleccionado',
                              '${game['name']} iniciado',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.black87,
                              colorText: Colors.white,
                            );
                            //Pasar a la pantalla de juego
                            Get.to(game['init']);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Imagen del juego
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    game['image'].toString(),
                                    width: double.infinity, // Ocupa todo el ancho disponible
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Nombre del juego
                                Text(
                                  game['name'].toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black54,
                                        offset: Offset(1, 1),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}