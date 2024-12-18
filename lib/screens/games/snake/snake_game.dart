import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:game_hub/screens/controllers/history_controller.dart';
import 'package:game_hub/screens/games/snake/blocs/game_flow_bloc.dart';
import 'package:game_hub/screens/games/snake/blocs/score_bloc.dart';
import 'package:game_hub/screens/games/snake/blocs/snake_bloc.dart';
import 'package:game_hub/screens/games/snake/components/ground/ground.dart';
import 'package:game_hub/screens/games/snake/game_config.dart';
import 'package:game_hub/screens/games/snake/init_snake.dart';
import 'package:game_hub/screens/games/snake/utils/direction_util.dart';
import 'package:get/get.dart';

class SnakeGame extends FlameGame
    with KeyboardEvents, HasCollisionDetection, DragCallbacks {
  final ScoreBloc scoreBloc;
  final GameFlowBloc gameFlowBloc;
  SnakeGame({
    required this.scoreBloc,
    required this.gameFlowBloc,
  });

  final SnakeBloc snakeBloc = SnakeBloc();

  @override
  Color backgroundColor() => const Color(0xFF578B33);

  Vector2? dragStartPosition;
  Vector2? dragLastPosition;

  Ground createGround() => Ground()
    ..position = Vector2(
      (size.x - GameConfig.columns * GameConfig.sizeCell) / 2,
      (size.y - GameConfig.rows * GameConfig.sizeCell) / 2,
    );

  @override
  onLoad() async {
    overlays.add(InitSnake.instructionsOverlay);
    await add(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<ScoreBloc, int>(
            create: () => scoreBloc,
          ),
          FlameBlocProvider<GameFlowBloc, GameState>(
            create: () => gameFlowBloc,
          ),
          FlameBlocProvider<SnakeBloc, SnakeState>(
            create: () => snakeBloc,
          ),
        ],
        children: [
          createGround(),
        ],
      ),
    );
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    dragStartPosition = event.localPosition;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    dragLastPosition = event.localStartPosition;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    final dragStartPosition = this.dragStartPosition;
    final dragLastPosition = this.dragLastPosition;

    if (dragLastPosition != null && dragStartPosition != null) {
      snakeBloc.add(
        DragScreenEvent(
          dragStartPosition: dragStartPosition,
          dragLastPosition: dragLastPosition,
        ),
      );
    }
    this.dragStartPosition = null;
    this.dragLastPosition = null;
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    dragStartPosition = null;
    dragLastPosition = null;
  }

  void startGame() {
    scoreBloc.add(ResetScore());
    gameFlowBloc.add(PlayEvent());
    overlays.remove(InitSnake.instructionsOverlay);
  }

  void gameOver() {
    // Obtener el puntaje actual
    final currentScore = scoreBloc.state;

    // Guardar el puntaje en la base de datos
    final controller = Get.find<HistoryController>();
    controller.addGameToHistory(
      name: 'Snake',
      score: currentScore,
      date: DateTime.now(),
    );

    // Cambiar estado del juego
    gameFlowBloc.add(LoseEvent());
    overlays.add(InitSnake.gameOverOverlay);

    // Reiniciar el estado de la serpiente
    snakeBloc.add(ResetSnakeEvent());
  }

  void playAgain() {
    startGame();
    overlays.remove('gameOverOverlay');
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is KeyDownEvent;

    if (gameFlowBloc.state == GameState.gameOver || !isKeyDown) {
      return KeyEventResult.ignored;
    }

    final direction = DirectionUtil.keyboardToDirection(keysPressed);

    if (direction == null) {
      return KeyEventResult.ignored;
    }

    if (gameFlowBloc.state == GameState.playing) {
      snakeBloc.add(UpdateDirectionEvent(directionRequested: direction));
    } else if (gameFlowBloc.state == GameState.intro) {
      startGame();
    }
    return KeyEventResult.handled;
  }
}
