import 'dart:async';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_hub/screens/games/tetris/core/enums/game_state.dart';
import 'package:game_hub/screens/games/tetris/core/utils/constants.dart';
import 'package:game_hub/screens/games/tetris/game/components/briks.dart';
import 'package:game_hub/screens/games/tetris/game/components/play_land.dart';
import 'package:game_hub/screens/games/tetris/game/components/status_land.dart';
import 'package:game_hub/screens/games/tetris/game/manager/audio_manager.dart';
import 'package:game_hub/screens/games/tetris/game/overlays/countdown_overlay.dart';
import 'package:game_hub/screens/games/tetris/game/overlays/play_again_overlay.dart';
import 'package:game_hub/screens/games/tetris/game/overlays/start_game_overlay.dart';
import 'package:game_hub/screens/games/tetris/game/providers/game_provider.dart';

class TetrisGame extends FlameGame with KeyboardEvents, TapCallbacks {
  final Size screenSize;

  Playland playland = Playland();
  StatusLand statusLand = StatusLand();
  GameProvider gameProvider = GameProvider();
  GameStates gameStates = GameStates.none;

  Timer? timer;

  // ignore: non_constant_identifier_names
  double WIDTH = 0;
// ignore: constant_identifier_names, non_constant_identifier_names
  double HEIGHT = 0;

  String startFrom = "";

  TetrisGame({
    required this.screenSize,
  });
  List<List<int>> mixed = [];
  List<Briks> briksPool = [];

  @override
  Color backgroundColor() => const Color(0xFF9EAD86);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size.setValues(screenSize.width, screenSize.height);
    WIDTH = 285;
    HEIGHT = 569;

    AudioManager.instance.initAudio();

    playland.y = playland.position.y = size.y * 0.12;
    playland.position.x = (size.x - WIDTH) / 2 - 5;

    statusLand.position.y = size.y * 0.02;
    statusLand.position.x = (size.x - WIDTH) / 2 - 5;

    addAll(
      [
        statusLand,
        playland,
      ],
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (gameStates == GameStates.none) {
      playAgain();
    } else if (gameStates == GameStates.paused) {
      pauseResumeGame();
    } else {
      rotate();
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is KeyDownEvent;

    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);
    final isArrowLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isArrowRight = keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final isArrowUp = keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isArrowDown = keysPressed.contains(LogicalKeyboardKey.arrowDown);
    final isKeyR = keysPressed.contains(LogicalKeyboardKey.keyR);

    if (isKeyDown && isSpace) {
      // playland.startOrDrop();

      return KeyEventResult.handled;
    } else if (isKeyDown && isArrowLeft) {
      playland.left();
      return KeyEventResult.handled;
    } else if (isKeyDown && isArrowRight) {
      playland.right();
      return KeyEventResult.handled;
    } else if (isKeyDown && isArrowUp) {
      playland.rotate();
      return KeyEventResult.handled;
    } else if (isKeyDown && isArrowDown) {
      playland.down(step: 3);
      return KeyEventResult.handled;
    } else if (isKeyDown && isKeyR) {
      playland.reset();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void startCountDown({required String key}) {
    startFrom = key;
    gameStates = GameStates.countdown;
    AudioManager.instance.selectSound();
    if (key == StartGameOverlay.keyOverlay) {
      overlays.remove(StartGameOverlay.keyOverlay);
    } else if (key == PlayAgainOverlay.keyOverlay) {
      overlays.remove(PlayAgainOverlay.keyOverlay);
    }

    overlays.add(CountdownOverlay.keyOverlay);
  }

  void endCountDown() {
    overlays.remove(CountdownOverlay.keyOverlay);
    if (startFrom == PlayAgainOverlay.keyOverlay) {
      playAgain();
    } else {
      startGame();
    }
  }

  void initTimer() {
    timer?.cancel();
    timer = null;
    timer = Timer.periodic(
      FALL_SPEED[gameProvider.level - 1],
      (timer) {
        moveDown();
      },
    );
  }

  void resetTimer() {
    timer?.cancel();
    timer = null;
  }

  void startGame() {
    if (gameStates == GameStates.running) {
      return;
    }
    gameProvider.start();
    playland.gameInit();
    AudioManager.instance.selectSound();
    AudioManager.instance.startBgm();
    AudioManager.instance.turnOnSound();
    initTimer();
  }

  void playAgain() {
    if (!gameProvider.startGame) {
      return;
    }
    playland.gameInit();
    initTimer();
    AudioManager.instance.stopBgm();
    AudioManager.instance.selectSound();
    AudioManager.instance.startBgm();
  }

  void pauseResumeGame() {
    if (!gameProvider.startGame) {
      return;
    }
    if (paused || gameStates == GameStates.paused) {
      gameStates = GameStates.running;
      AudioManager.instance.resumeBgm();
      initTimer();
      gameProvider.pause(false);
      resumeEngine();
    } else {
      gameStates = GameStates.paused;
      resetTimer();
      AudioManager.instance.pauseBgm();
      gameProvider.pause(true);
      pauseEngine();
    }
  }

  void pauseResumeSound() {
    if (!gameProvider.startGame) {
      return;
    }
    if (gameProvider.playSound) {
      AudioManager.instance.turnOffSound();
    } else {
      AudioManager.instance.turnOnSound();
    }
    gameProvider.sound();
  }

  void resetGame() {
    if (!gameProvider.startGame) {
      return;
    }
    if (gameStates == GameStates.none ||
        gameStates == GameStates.reset ||
        gameStates == GameStates.paused) {
      return;
    }
    // Reiniciar el tablero
    playland.reset();
  }

  void moveLeft() {
    if (!gameProvider.startGame) {
      return;
    }
    if (gameStates != GameStates.running) {
      return;
    }
    playland.left();
  }

  void moveRight() {
    if (!gameProvider.startGame) {
      return;
    }
    if (gameStates != GameStates.running) {
      return;
    }
    playland.right();
  }

  void moveDown() {
    if (!gameProvider.startGame) {
      return;
    }
    if (gameStates != GameStates.running) {
      return;
    }
    playland.down();
  }

  void rotate() {
    if (!gameProvider.startGame) {
      return;
    }
    if (gameStates != GameStates.running) {
      return;
    }
    playland.rotate();
  }

  void quickMoveDown() {
    if (!gameProvider.startGame) {
      return;
    }
    if (gameStates != GameStates.running) {
      return;
    }
    AudioManager.instance.moveSound();
    playland.down(step: 3);
  }

  void quickDrop() {
    if (!gameProvider.startGame) {
      return;
    }
    if (gameStates != GameStates.running) {
      return;
    }
    playland.drop();
  }

  void exitGame() {
    // Detener la música si está activa
    if (gameProvider.playSound) {
      AudioManager.instance.turnOffSound();
      AudioManager.instance.stopBgm();
    }
    // Limpiar el temporizador
    resetTimer();

    // Reiniciar el estado del juego
    gameProvider.reset();
    gameStates = GameStates.none;
    playland.reset();
  }
}
