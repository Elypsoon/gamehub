import 'package:flutter/material.dart';
import 'package:game_hub/screens/controllers/history_controller.dart';
import 'package:get/get.dart';
import 'package:zhi_starry_sky/starry_sky.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.put(HistoryController());

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
                // Barra superior
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: const Text(
                    'Historial de Juegos',
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: [
                    IconButton(
                      icon:
                          const Icon(Icons.delete_forever, color: Colors.white),
                      onPressed: () async {
                        // Confirmación antes de limpiar el historial
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('¿Borrar todo?'),
                              content: const Text(
                                  '¿Estás seguro de que deseas borrar todo el historial?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Borrar'),
                                ),
                              ],
                            );
                          },
                        );
                        if (result == true) {
                          await controller.clearHistory();
                        }
                      },
                    ),
                  ],
                ),
                // Contenido del historial
                Expanded(
                  child: Obx(() {
                    if (controller.gameHistory.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No hay nada que mostrar. ¡Comienza a jugar!',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Icon(Icons.all_inclusive,
                                size: 48, color: Colors.white),
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          // Encabezado de la tabla
                          Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.lightBlueAccent.withOpacity(0.5),
                            child: const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Juego',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Nombre',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Puntuación',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Fecha',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Filas de la tabla
                          ...controller.gameHistory.map((game) {
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.lightBlueAccent
                                          .withOpacity(0.5)),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${game.id}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(game.name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${game.score}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      game.date
                                          .toLocal()
                                          .toString()
                                          .split(' ')[0],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
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
