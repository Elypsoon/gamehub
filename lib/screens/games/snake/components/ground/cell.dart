import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_hub/screens/games/snake/game_config.dart';

class Cell extends RectangleComponent {
  final Color color;
  Cell({
    required this.color,
    required Vector2 position,
  }) : super(
          size: Vector2.all(GameConfig.sizeCell),
          position: position,
        ) {
    setColor(color);
  }
}
