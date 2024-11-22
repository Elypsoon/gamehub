import 'package:game_hub/screens/controllers/achievements.dart';
import 'package:game_hub/screens/controllers/db_manage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AchievementsController extends GetxController {
  final gameHistory = <GameHistory>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadGameHistory();
  }
  // Método para cargar el historial desde la base de datos
  Future<void> loadGameHistory() async {
    final history = await DBHelper.instance.getAllGames();
    gameHistory.assignAll(history);
  }

  // Verifica si un logro está desbloqueado
  bool isAchievementUnlocked(Achievement achievement) {
    return achievement.isUnlocked(gameHistory);
  }
}