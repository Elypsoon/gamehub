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
                      icon: const Icon(Icons.delete_forever, color: Colors.white),
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
                                  onPressed: () => Navigator.pop(context, false),
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
                        child: Text(
                          'No hay juegos en el historial',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          // Encabezado de la tabla
                          Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.grey[200]?.withOpacity(0.5),
                            child: const Row(
                              children: [
                                Expanded(
                                    child: Text('Juego (ID)',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    child: Text('Nombre',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    child: Text('Puntuación',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    child: Text('Fecha',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                SizedBox(width: 40), // Espacio para botón
                              ],
                            ),
                          ),
                          // Filas de la tabla
                          ...controller.gameHistory.map((game) {
                            return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey[300]!.withOpacity(0.5)),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(child: Text('${game.id}')),
                                  Expanded(child: Text(game.name)),
                                  Expanded(child: Text('${game.score}')),
                                  Expanded(
                                      child: Text(
                                          game.date.toLocal().toString().split(' ')[0])),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => controller.deleteGame(game.id!),
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