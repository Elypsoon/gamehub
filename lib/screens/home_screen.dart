import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zhi_starry_sky/starry_sky.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de la pantalla (imagen)
          const Positioned.fill(
            child: Center(
              child: StarrySkyView(),
            )
          ),
          // Contenido principal
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nombre de la aplicación
                const Text(
                  'GameHub',
                  style: TextStyle(
                    fontSize: 48,
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
                const SizedBox(height: 50), // Espaciado entre el título y los botones
                // Botones del menú
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botón de Logros
                    _buildMenuButton(
                      icon: Icons.emoji_events,
                      color: Colors.blueAccent,
                      onPressed: () {
                        Get.toNamed('/achievements');
                      },
                    ),
                    const SizedBox(width: 30), // Separación horizontal
                    // Botón de Play (más grande)
                    _buildMenuButton(
                      icon: Icons.play_arrow,
                      color: Colors.green,
                      isLarge: true,
                      onPressed: () {
                        Get.toNamed('/games');
                      },
                    ),
                    const SizedBox(width: 30), // Separación horizontal
                    // Botón de Historial
                    _buildMenuButton(
                      icon: Icons.history,
                      color: Colors.orange,
                      onPressed: () {
                        Get.toNamed('/history');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    bool isLarge = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: const CircleBorder(),
        padding: EdgeInsets.all(isLarge ? 24 : 16),
        elevation: 8,
        shadowColor: Colors.black54,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: isLarge ? 48 : 32,
      ),
    );
  }
}
