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
    name: 'Novato',
    description: 'Juega tu primera partida.',
    iconPath: 'assets/images/cielo.jpg',
    isUnlocked: (history) => history.isNotEmpty,
  ),
  Achievement(
    id: 2,
    name: 'Pro Flappy Bird',
    description: 'Alcanza un puntaje de 5 en Flappy Bird.',
    iconPath: 'assets/images/cielo.jpg',
    isUnlocked: (history) => history.any((game) =>
        game.name == 'Flappy Bird' && game.score >= 5),
  ),
  Achievement(
    id: 3,
    name: 'Persistente',
    description: 'Juega 10 partidas en total.',
    iconPath: 'assets/images/cielo.jpg',
    isUnlocked: (history) => history.length >= 10,
  ),
];

