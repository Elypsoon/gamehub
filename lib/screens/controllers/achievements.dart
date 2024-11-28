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
    isUnlocked: (history) => history.any((game) =>
        game.name == 'Flappy Bird' && game.score >= 30),
  ),
  Achievement(
    id: 3,
    name: 'Experimentado',
    description: 'Juega 100 partidas en total.',
    iconPath: 'assets/images/persistente.png',
    isUnlocked: (history) => history.length >= 100,
  ),
];

