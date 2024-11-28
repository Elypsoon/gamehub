import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:game_hub/screens/games/flappy_bird/components/pipe.dart';
import 'package:game_hub/screens/games/flappy_bird/game/assets.dart';
import 'package:game_hub/screens/games/flappy_bird/game/configuration.dart';
import 'package:game_hub/screens/games/flappy_bird/game/flappy_bird_game.dart';
import 'package:game_hub/screens/games/flappy_bird/game/pipe_position.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  PipeGroup();

  final _random = Random();

  @override
Future<void> onLoad() async {
  position.x = gameRef.size.x;

  final heightMinusGround = gameRef.size.y - Config.groundHeight;
  
  // Define el espacio mínimo y máximo entre tuberías consecutivas
  const minSpacing = 150.0; // Espaciado mínimo entre tuberías
  const maxSpacing = 200.0; // Espaciado máximo entre tuberías
  const maxHeightDifference = 120.0; // Máxima diferencia de altura entre tuberías consecutivas

  // Calcula un espaciado dentro del rango permitido
  final spacing = minSpacing + _random.nextDouble() * (maxSpacing - minSpacing);

  // Calcula el centroY, asegurando que la diferencia con la última tubería no sea extrema
  double centerY;
  if (parent is! PipeGroup || (gameRef.children.whereType<PipeGroup>().isEmpty)) {
    // Si no hay una tubería previa, el centro se genera aleatoriamente
    centerY = heightMinusGround / 2 + _random.nextDouble() * (heightMinusGround / 4);
  } else {
    final lastPipeGroup = gameRef.children
        .whereType<PipeGroup>()
        .reduce((a, b) => a.position.x > b.position.x ? a : b);

    final lastCenterY = lastPipeGroup.children
        .whereType<Pipe>()
        .map((pipe) => pipe.pipePosition == PipePosition.top
            ? pipe.height
            : heightMinusGround - pipe.height)
        .reduce((a, b) => (a + b) / 2);

    // Asegura que el nuevo centroY no exceda la diferencia máxima de altura
    centerY = (lastCenterY +
            (-maxHeightDifference + _random.nextDouble() * (maxHeightDifference * 2)))
        .clamp(spacing, heightMinusGround - spacing);
  }

  addAll([
    Pipe(pipePosition: PipePosition.top, height: centerY - spacing / 2),
    Pipe(
      pipePosition: PipePosition.bottom,
      height: heightMinusGround - (centerY + spacing / 2),
    ),
  ]);
}


  void updateScore() {
    gameRef.bird.score += 1;
    FlameAudio.play(Assets.point);
  }

  @override
void update(double dt) {
  super.update(dt);
  position.x -= Config.gameSpeed * dt;

  if (position.x < -10) {
    removeFromParent(); // Elimina este grupo de tuberías del árbol de componentes
    gameRef.bird.score += 1; // Aumenta la puntuación
  }

  if (gameRef.isHit) {
    removeFromParent(); // Asegúrate de eliminar las tuberías al colisionar
    gameRef.isHit = false;
  }
}

}
