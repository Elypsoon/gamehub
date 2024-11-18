import 'package:game_hub/screens/controllers/db_manage.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  var gameHistory = <GameHistory>[].obs; // Lista observable

  @override
  void onInit() {
    super.onInit();
    fetchGameHistory(); // Cargar datos al iniciar
  }

  Future<void> fetchGameHistory() async {
    final dbHelper = DBHelper.instance;
    final fetchedHistory = await dbHelper.getAllGames();
    gameHistory.assignAll(fetchedHistory); // Actualiza la lista observable
  }

  Future<void> deleteGame(int id) async {
    final dbHelper = DBHelper.instance;
    await dbHelper.deleteGame(id);
    fetchGameHistory(); // Recargar datos después de borrar
  }

  Future<void> clearHistory() async {
    final dbHelper = DBHelper.instance;
    await dbHelper.clearHistory();
    fetchGameHistory(); // Recargar datos después de limpiar
  }
}
