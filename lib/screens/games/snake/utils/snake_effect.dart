import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/widgets.dart';
import 'package:game_hub/screens/games/snake/game_config.dart';
import 'package:game_hub/screens/games/snake/utils/direction_util.dart';


class SnakeEffect {
  static List<Effect> createHeadEffect({
    required PositionComponent component,
    required Direction previousDirection,
    required Direction direction,
    required Direction Function() onComplete,
  }) {
    return [
      MoveByEffect(
        DirectionUtil.directionToVector(direction),
        EffectController(
          duration: GameConfig.snakeMovementDuration,
          curve: Curves.linear,
        ),
        onComplete: () {
          final newDirection = onComplete();
          component.addAll(createHeadEffect(
            component: component,
            previousDirection: direction,
            onComplete: onComplete,
            direction: newDirection,
          ));
        },
      )..removeOnFinish = true,
      RotateEffect.by(
        getAngleFrom(
          previousDirection: previousDirection,
          direction: direction,
        ),
        EffectController(
          duration: GameConfig.snakeMovementDuration * 2 / 3,
          curve: Curves.linear,
        ),
      )
    ];
  }

  static List<Effect> createBodyEffect({
    required PositionComponent component,
    required int indexHistory,
    required List<Vector2> offset,
    required List<Vector2> headHistory,
    required int indexBodyPart,
    required List<Vector2> Function({
      required int indexBodyPart,
      required int indexHistory,
      required Direction direction,
    }) onComplete,
  }) {
    final List<Vector2> completeHistory = [
      ...offset,
      ...headHistory,
    ];
    final startPosition = component.position;
    return [
      MoveByEffect(
        completeHistory[indexHistory],
        EffectController(
          duration: GameConfig.snakeMovementDuration,
          curve: Curves.linear,
        ),
        onComplete: () {
          final newIndexHistory = indexHistory + 1;
          final newHistory = onComplete(
              indexBodyPart: indexBodyPart,
              indexHistory: newIndexHistory,
              direction: DirectionUtil.vectorsToDirection(
                startPosition,
                startPosition + completeHistory[indexHistory],
              ));
          component.addAll(createBodyEffect(
            component: component,
            indexHistory: newIndexHistory,
            offset: offset,
            headHistory: newHistory,
            onComplete: onComplete,
            indexBodyPart: indexBodyPart,
          ));
        },
      )..removeOnFinish = true,
    ];
  }

  static double getAngleFrom({
    required Direction direction,
    required Direction previousDirection,
  }) {
    Never throwError() {
      return throw StateError(
          'from $previousDirection to $direction should not happen');
    }

    return switch ((previousDirection, direction)) {
      (Direction.right, Direction.down) => pi / 2,
      (Direction.down, Direction.left) => pi / 2,
      (Direction.left, Direction.up) => pi / 2,
      (Direction.up, Direction.right) => pi / 2,
      (Direction.right, Direction.up) => -pi / 2,
      (Direction.up, Direction.left) => -pi / 2,
      (Direction.left, Direction.down) => -pi / 2,
      (Direction.down, Direction.right) => -pi / 2,
      (Direction.up, Direction.up) => 0,
      (Direction.left, Direction.left) => 0,
      (Direction.down, Direction.down) => 0,
      (Direction.right, Direction.right) => 0,
      (Direction.up, Direction.down) => throwError(),
      (Direction.down, Direction.up) => throwError(),
      (Direction.left, Direction.right) => throwError(),
      (Direction.right, Direction.left) => throwError(),
    };
  }
}
