import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:game_hub/screens/games/snake/blocs/game_flow_bloc.dart';
import 'package:game_hub/screens/games/snake/blocs/score_bloc.dart';
import 'package:game_hub/screens/games/snake/blocs/snake_bloc.dart';
import 'package:game_hub/screens/games/snake/components/snake/snake_body_part.dart';
import 'package:game_hub/screens/games/snake/components/snake/snake_head.dart';
import 'package:game_hub/screens/games/snake/game_config.dart';
import 'package:game_hub/screens/games/snake/snake_game.dart';
import 'package:game_hub/screens/games/snake/utils/direction_util.dart';
import 'package:game_hub/screens/games/snake/utils/snake_effect.dart';

class Snake extends PositionComponent
    with HasGameRef<SnakeGame>, FlameBlocReader<SnakeBloc, SnakeState> {
  final List<PositionComponent> bodyParts = [];

  Snake() : super(priority: 1);

  bool hasStarted = false;
  int lastIndexHistory = 0;
  Direction lastBodyPartDirection = Direction.right;
  final List<Vector2> moveHeadHistory = [];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    bodyParts
      ..clear()
      ..addAll(
        List.generate(GameConfig.lengthSnake, (index) {
          if (index == 0) {
            return SnakeHead(
              whenEatFood: whenEatFood,
              whenDead: whenDead,
            );
          }

          return SnakeBodyPart(hasHitbox: index != 1)
            ..position = -Vector2(GameConfig.sizeCell * index, 0);
        }),
      );

    addAll(bodyParts);

    await add(
      FlameBlocListener<GameFlowBloc, GameState>(
        listenWhen: (previousState, newState) {
          return newState == GameState.gameOver;
        },
        onNewState: (state) {
          for (final bodyPart in bodyParts) {
            bodyPart.removeWhere((component) => component is Effect);
          }
        },
      ),
    );
  }

  @override
  void update(double dt) {
    if (!hasStarted && gameRef.gameFlowBloc.state == GameState.playing) {
      hasStarted = true;
      moveHeadHistory.add(DirectionUtil.directionToVector(Direction.right));
      final effect = SnakeEffect.createHeadEffect(
        direction: Direction.right,
        onComplete: onCompleteHeadEffect,
        component: bodyParts.first,
        previousDirection: Direction.right,
      );
      bodyParts.first.addAll(effect);
      for (var i = 1; i < bodyParts.length; i++) {
        bodyParts[i].addAll(
          SnakeEffect.createBodyEffect(
            component: bodyParts[i],
            indexHistory: 0,
            offset: createOffsetBodyPart(i),
            headHistory: moveHeadHistory,
            onComplete: onCompleteBodyEffect,
            indexBodyPart: i,
          ),
        );
      }
    }
  }

  List<Vector2> createOffsetBodyPart(int i) {
    return List.generate(
      i,
      (index) => DirectionUtil.directionToVector(Direction.right),
    );
  }

  void whenDead() {
    gameRef.gameOver();
  }

  void whenEatFood() {
    gameRef.scoreBloc.add(IncrementScore()); // Usar gameRef para acceder a scoreBloc
    final newBodyPart = SnakeBodyPart(hasHitbox: true)
      ..position = bodyParts.last.position -
          DirectionUtil.directionToVector(lastBodyPartDirection);
    bodyParts.add(newBodyPart);
    add(newBodyPart);
    final offset = createOffsetBodyPart(bodyParts.length - 1);
    newBodyPart.addAll(SnakeEffect.createBodyEffect(
      component: newBodyPart,
      indexHistory: lastIndexHistory,
      offset: offset,
      headHistory: moveHeadHistory,
      onComplete: onCompleteBodyEffect,
      indexBodyPart: bodyParts.length - 1,
    ));
  }

  Direction onCompleteHeadEffect() {
    final direction = bloc.state.direction;
    moveHeadHistory.add(DirectionUtil.directionToVector(direction));
    return direction;
  }

  List<Vector2> onCompleteBodyEffect({
    required int indexBodyPart,
    required int indexHistory,
    required Direction direction,
  }) {
    if (indexBodyPart == bodyParts.length - 1) {
      lastIndexHistory = indexHistory;
      lastBodyPartDirection = direction;
    }
    return moveHeadHistory;
  }
}
