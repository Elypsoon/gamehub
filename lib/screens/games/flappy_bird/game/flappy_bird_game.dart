import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:game_hub/screens/games/flappy_bird/components/background.dart';
import 'package:game_hub/screens/games/flappy_bird/components/bird.dart';
import 'package:game_hub/screens/games/flappy_bird/components/ground.dart';
import 'package:game_hub/screens/games/flappy_bird/components/pipe_group.dart';
import 'package:game_hub/screens/games/flappy_bird/game/configuration.dart';

// Clase que representa el juego de Flappy Bird, aquí se añaden los componentes del juego
class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  FlappyBirdGame();

  late Bird bird;
  Timer interval = Timer(Config.pipeInterval, repeat: true);
  bool isHit = false;
  late TextComponent score;

  @override
  @override
  Future<void> onLoad() async {
    addAll([
      Background()..priority = 0,
      Ground()..priority = 1,
      bird = Bird()..priority = 2,
      score = buildScore()..priority = 4,
    ]);

    // Configuración del temporizador
    interval = Timer(
      Config.pipeInterval,
      repeat: true,
      onTick: () => add(PipeGroup()),
    );

    // Inicia el temporizador con un retraso inicial
    Future.delayed(const Duration(milliseconds: 100), () => interval.start());
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt); // Asegúrate de que el temporizador se actualice
    score.text = 'Puntuación: ${bird.score}';
  }

  TextComponent buildScore() {
    return TextComponent(
      position: Vector2(size.x / 2, size.y / 2 * 0.2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 40,
          fontFamily: 'Game',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void onTap() {
    bird.fly();
  }
}
