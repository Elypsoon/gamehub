import 'package:flutter/material.dart';
import 'package:game_hub/screens/controllers/achievements.dart';
import 'package:game_hub/screens/controllers/achievements_controller.dart';
import 'package:get/get.dart';
import 'package:zhi_starry_sky/starry_sky.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AchievementsController controller =
        Get.put(AchievementsController());

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
                // Título
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: const Text(
                    'Logros',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    final history = controller.gameHistory;

                    if (history.isEmpty) {
                      //No quites este if ya que si no hay historial salen errores
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: achievements.length,
                      itemBuilder: (context, index) {
                        final achievement = achievements[index];
                        final isUnlocked =
                            controller.isAchievementUnlocked(achievement);

                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(achievement.name),
                                  content: Text(achievement.description),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Cerrar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Column(
                            children: [
                              // Ícono del logro
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(achievement.iconPath),
                                      fit: BoxFit.cover,
                                      colorFilter: isUnlocked
                                          ? null
                                          : const ColorFilter.mode(
                                              Colors.grey, BlendMode.saturation),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Nombre del logro
                              Text(
                                achievement.name,
                                style: TextStyle(
                                  color: isUnlocked
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                  fontWeight: isUnlocked
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
