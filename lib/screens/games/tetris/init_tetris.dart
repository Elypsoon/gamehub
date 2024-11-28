import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_hub/screens/games/tetris/core/utils/user_manager.dart';
import 'package:game_hub/screens/games/tetris/game/overlays/control_game.dart';
import 'package:game_hub/screens/games/tetris/game/overlays/countdown_overlay.dart';
import 'package:game_hub/screens/games/tetris/game/overlays/play_again_overlay.dart';
import 'package:game_hub/screens/games/tetris/game/overlays/score_game_overlay.dart';
import 'package:game_hub/screens/games/tetris/game/overlays/start_game_overlay.dart';
import 'package:game_hub/screens/games/tetris/game/tetris_game.dart';


class InitTetris extends StatefulWidget {
  const InitTetris({super.key});

  @override
  State<InitTetris> createState() => _InitTetrisState();
}

class _InitTetrisState extends State<InitTetris> {
  // This widget is the root of your application.
  late TetrisGame game;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    UserManagement().navigatorKey = _navigatorKey;
  }

  @override
  Widget build(BuildContext context) {
    game = TetrisGame(
      screenSize: MediaQuery.of(context).size,
    );
    bool isLeftRightBusy = false;
    bool slowDown = false;
    UserManagement().getScreenHeight = MediaQuery.of(context).size.height;
    UserManagement().getScreenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false, // <--- This line
      title: 'Tetris Game',
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaler: const TextScaler.linear(1)),
          child: GestureDetector(
              onHorizontalDragUpdate: (DragUpdateDetails details) async {
                if (!isLeftRightBusy) {
                  isLeftRightBusy = true;

                  double sensitivity = 0.01;
                  double delta = details.primaryDelta! * sensitivity;

                  if (delta > 0) {
                    game.moveRight();
                  } else if (delta < 0) {
                    game.moveLeft();
                  }

                  // Introduce a delay, adjust the duration as needed
                  await Future.delayed(const Duration(milliseconds: 90));

                  isLeftRightBusy = false;
                }
              },
              onVerticalDragUpdate: (DragUpdateDetails details) {
                if (details.primaryDelta! > 16) {
                  game.quickDrop();
                }
                if (!slowDown) {
                  slowDown = true;

                  double sensitivity = 0.01;
                  double delta = details.primaryDelta! * sensitivity;

                  if (delta > 0) {
                    game.quickMoveDown();
                  }

                  Future.delayed(const Duration(milliseconds: 50), () {
                    slowDown = false;
                  });
                }
              },
              child: SafeArea(child: child!)),
        );
      },
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(0),
          color: const Color(0xFF9EAD86),
          child: GameWidget.controlled(
              initialActiveOverlays: [
                ScoreGameOverlay.keyOverlay,
                ControlGame.keyOverlay,
                StartGameOverlay.keyOverlay,
              ],
              gameFactory: () => game,
              overlayBuilderMap: {
                ControlGame.keyOverlay: (context, game) => ControlGame(
                      game: game as TetrisGame,
                    ),
                StartGameOverlay.keyOverlay: (context, game) =>
                    StartGameOverlay(
                      game: game as TetrisGame,
                    ),
                PlayAgainOverlay.keyOverlay: (context, game) =>
                    PlayAgainOverlay(
                      game: game as TetrisGame,
                    ),
                CountdownOverlay.keyOverlay: (context, game) =>
                    CountdownOverlay(
                      game: game as TetrisGame,
                    ),
                ScoreGameOverlay.keyOverlay: (context, game) =>
                    ScoreGameOverlay(
                      game: game as TetrisGame,
                    ),
              }),
        ),
      ),
    );
  }
}
