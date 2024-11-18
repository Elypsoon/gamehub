import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:game_hub/screens/games/flappy_bird/game/assets.dart';
import 'package:game_hub/screens/games/flappy_bird/game/bird_movement.dart';
import 'package:game_hub/screens/games/flappy_bird/game/configuration.dart';
import 'package:game_hub/screens/games/flappy_bird/game/flappy_bird_game.dart';

// Clase que representa al pájaro del juego
class Bird extends SpriteGroupComponent<BirdMovement>
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Bird();

  int score = 0;

  @override
  Future<void> onLoad() async {
    // Carga los sprites del pájaro
    final birdMidFlap = await gameRef.loadSprite(Assets.birdMidFlap);
    final birdUpFlap = await gameRef.loadSprite(Assets.birdUpFlap);
    final birdDownFlap = await gameRef.loadSprite(Assets.birdDownFlap);

    // Define el tamaño y posición del pájaro
    size = Vector2(50, 40);
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);

    // Asigna los sprites al mapa y establece el sprite inicial
    sprites = {
      BirdMovement.middle: birdMidFlap,
      BirdMovement.up: birdUpFlap,
      BirdMovement.down: birdDownFlap,
    };

    // Verifica que los sprites se hayan asignado correctamente
    assert(sprites != null && sprites!.isNotEmpty, 'Sprites not set correctly');

    // Establece el sprite inicial después de la asignación
    current = BirdMovement.middle;

    // Agrega el hitbox para colisiones
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += Config.birdVelocity * dt;
    if (position.y < 1) {
      gameOver();
    }
  }

  void fly() {
    // Asegúrate de que los sprites estén listos antes de cambiar el estado
    if (sprites != null && sprites![BirdMovement.up] != null) {
      current = BirdMovement.up; // Cambia el estado a volar hacia arriba

      add(
        MoveByEffect(
          Vector2(0, Config.gravity),
          EffectController(duration: 0.2, curve: Curves.decelerate),
          onComplete: () => current = BirdMovement.down,
        ),
      );
      FlameAudio.play(Assets.flying);
    } else {
      debugPrint('Sprites not loaded properly, cannot change to BirdMovement.up');
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    gameOver();
  }

  void reset() {
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    score = 0;
  }

  void gameOver() {
    FlameAudio.play(Assets.collision);
    game.isHit = true;
    gameRef.overlays.add('gameOver');
    gameRef.pauseEngine();
  }
}
