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
  Future<void> onLoad() async {
    addAll([
      Background()..priority = 0,
      Ground()..priority = 1,
      bird = Bird()..priority = 2,
      PipeGroup()..priority = 3, // Las tuberías tienen menor prioridad que el texto
      score = buildScore()..priority = 4,
    ]);

    interval.onTick = () => add(PipeGroup());
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

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);
    score.text = 'Puntuación: ${bird.score}';
  }
}
