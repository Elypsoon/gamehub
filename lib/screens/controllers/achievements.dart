import 'package:game_hub/screens/controllers/db_manage.dart';

class Achievement {
  final int id;
  final String name;
  final String description;
  final String iconPath;
  final bool Function(List<GameHistory>) isUnlocked;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.isUnlocked,
  });
}

final achievements = [
  Achievement(
    id: 1,
    name: 'Primer paso',
    description: 'Juega tu primera partida.',
    iconPath: 'assets/images/1.png',
    isUnlocked: (history) => history.isNotEmpty,
  ),
  Achievement(
    id: 2,
    name: 'Pro Flappy Bird',
    description: 'Alcanza un puntaje de 30 en Flappy Bird.',
    iconPath: 'assets/images/flappyBirdPro.png',
    isUnlocked: (history) =>
        history.any((game) => game.name == 'Flappy Bird' && game.score >= 30),
  ),
  Achievement(
    id: 3,
    name: 'Experimentado',
    description: 'Juega 100 partidas en total.',
    iconPath: 'assets/images/persistente.png',
    isUnlocked: (history) => history.length >= 100,
  ),
  Achievement(
    id: 4,
    name: 'Snake Master',
    description: 'Alcanza un puntaje de 30 en Snake.',
    iconPath: 'assets/images/snakePro.png',
    isUnlocked: (history) =>
        history.any((game) => game.name == 'Snake' && game.score >= 30),
  ),
  Achievement(
    id: 5,
    name: 'Tetris Pro',
    description: 'Alcanza un puntaje de 100 en Tetris.',
    iconPath: 'assets/images/tetrisPro.png',
    isUnlocked: (history) =>
        history.any((game) => game.name == 'Tetris' && game.score >= 100),
  ),
  Achievement(
    id: 6,
    name: '¿Primera vez?',
    description: 'Consigue 20 partidas de Flappy Bird con un puntaje de 0.',
    iconPath: 'assets/images/flappyF.png',
    isUnlocked: (history) =>
        history
            .where((game) => game.name == 'Flappy Bird' && game.score == 0)
            .length >=
        20,
  ),
  Achievement(
    id: 7,
    name: 'Diverso',
    description: 'Juega al menos una vez a todos los juegos disponibles.',
    iconPath: 'assets/images/universal.png',
    isUnlocked: (history) {
      const gameNames = ['Flappy Bird', 'Snake', 'Tetris', 'Dino Run'];
      final playedGames = history.map((game) => game.name).toSet();
      return gameNames.every(playedGames.contains);
    },
  ),
  Achievement(
    id: 8,
    name: 'Ay',
    description:
        'Consigue 10 partidas consecutivas con putuación de 0 en cualquier juego.',
    iconPath: 'assets/images/ay.png',
    isUnlocked: (history) {
      if (history.length < 10) return false;
      for (int i = 0; i <= history.length - 10; i++) {
        final recentGames = history.sublist(i, i + 10);
        if (recentGames.every((game) => game.score == 0)) return true;
      }
      return false;
    },
  ),
  Achievement(
    id: 9,
    name: 'Ardiente',
    description: 'Logra un puntaje mayor a 40 en 5 partidas consecutivas.',
    iconPath: 'assets/images/ardiente.png',
    isUnlocked: (history) {
      if (history.length < 5) return false;
      for (int i = 0; i <= history.length - 5; i++) {
        final recentGames = history.sublist(i, i + 5);
        if (recentGames.every((game) => game.score > 40)) return true;
      }
      return false;
    },
  ),
  Achievement(
    id: 10,
    name: 'Supremasía en Tetris',
    description:
        'Logra un puntaje mayor a 100 en 5 partidas consecutivas de Tetris.',
    iconPath: 'assets/images/tetrisStreak.png',
    isUnlocked: (history) {
      final tetrisGames =
          history.where((game) => game.name == 'Tetris').toList();
      if (tetrisGames.length < 5) return false;

      for (int i = 0; i <= tetrisGames.length - 5; i++) {
        final recentGames = tetrisGames.sublist(i, i + 5);
        if (recentGames.every((game) => game.score > 100)) return true;
      }
      return false;
    },
  ),
  Achievement(
    id: 11,
    name: 'Dino Run Master',
    description: 'Alcanza un puntaje de 300 en DinoRun.',
    iconPath: 'assets/images/dinoMaster.png',
    isUnlocked: (history) =>
        history.any((game) => game.name == 'Dino Run' && game.score >= 300),
  ),
  Achievement(
    id: 12,
    name: 'Adicto al pájaro',
    description: 'Juega 100 partidas de Flappy Bird.',
    iconPath: 'assets/images/flappyAdiction.png',
    isUnlocked: (history) =>
        history.where((game) => game.name == 'Flappy Bird').length >= 100,
  ),
  Achievement(
    id: 13,
    name: 'Adicto a correr',
    description: 'Juega 100 partidas de Dino Run.',
    iconPath: 'assets/images/dinoAdiction.png',
    isUnlocked: (history) =>
        history.where((game) => game.name == 'Dino Run').length >= 100,
  ),
  Achievement(
    id: 14,
    name: 'Adicto a las manzanas',
    description: 'Juega 100 partidas de Snake.',
    iconPath: 'assets/images/snakeAdiction.png',
    isUnlocked: (history) =>
        history.where((game) => game.name == 'Snake').length >= 100,
  ),
  Achievement(
    id: 15,
    name: 'Adicto a los cubos',
    description: 'Juega 100 partidas de Tetris.',
    iconPath: 'assets/images/tetrisAdiction.png',
    isUnlocked: (history) =>
        history.where((game) => game.name == 'Tetris').length >= 100,
  ),
  Achievement(
    id: 16,
    name: 'Navideño',
    description: 'Juega al menos 5 partidas en Navidad.',
    iconPath: 'assets/images/navideño.png',
    isUnlocked: (history) =>
        history.where((game) => game.date.month == 12 && game.date.day == 25).length >= 5,
  ),
  Achievement(
    id: 17,
    name: 'Ultra Experimentado',
    description: 'Juega 1000 partidas en total.',
    iconPath: 'assets/images/ultraPro.png',
    isUnlocked: (history) =>
        history.length >= 1000,
  ),
  Achievement(
    id: 18,
    name: 'Universal',
    description: 'Consigue 15 puntos en Flappy Bird, 20 en snake, 50 en tetris y 150 en dino run.',
    iconPath: 'assets/images/gamerU.png',
    isUnlocked: (history) =>
        history.any((game) => game.name == 'Flappy Bird' && game.score >= 15) &&
        history.any((game) => game.name == 'Snake' && game.score >= 20) &&
        history.any((game) => game.name == 'Tetris' && game.score >= 50) &&
        history.any((game) => game.name == 'Dino Run' && game.score >= 150),
  ),
];
