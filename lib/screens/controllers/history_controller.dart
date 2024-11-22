import 'package:game_hub/screens/controllers/db_manage.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  var gameHistory = <GameHistory>[].obs;
  var filteredGameHistory = <GameHistory>[].obs;
  var selectedGame = 'Todos los juegos'.obs;
  var selectedOrder = 'Recientes'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGameHistory();
  }

  Future<void> fetchGameHistory() async {
    final data = await DBHelper.instance.getAllGames();
    gameHistory.assignAll(data);
    applyFilters();
  }

  void updateFilter(String game) {
    selectedGame.value = game;
    applyFilters();
  }

  void updateOrder(String order) {
    selectedOrder.value = order;
    applyFilters();
  }

  void applyFilters() {
    List<GameHistory> tempHistory = gameHistory;

    // Filtrar por juego
    if (selectedGame.value != 'Todos los juegos') {
      tempHistory = tempHistory
          .where((game) => game.name == selectedGame.value)
          .toList();
    }

    // Ordenar
    if (selectedOrder.value == 'Mayor puntaje') {
      tempHistory.sort((a, b) => b.score.compareTo(a.score));
    } else {
      tempHistory.sort((a, b) => a.id!.compareTo(b.id as num));
    }

    filteredGameHistory.assignAll(tempHistory);
  }

  Future<void> clearHistory() async {
    await DBHelper.instance.clearHistory();
    fetchGameHistory();
  }

  Future<void> addGameToHistory({required String name, required int score, required DateTime date}) async{
    final dbHelper = DBHelper.instance;
    await dbHelper.insertGame(GameHistory(name: name, score: score, date: date));
    fetchGameHistory(); // Recargar datos después de añadir
  }
}
