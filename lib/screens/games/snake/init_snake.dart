import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_hub/screens/games/snake/blocs/game_flow_bloc.dart';
import 'package:game_hub/screens/games/snake/blocs/score_bloc.dart';
import 'package:game_hub/screens/games/snake/overlays/game_over_overlay.dart';
import 'package:game_hub/screens/games/snake/overlays/instructions_overlay.dart';
import 'package:game_hub/screens/games/snake/overlays/score_overlay.dart';
import 'package:game_hub/screens/games/snake/snake_game.dart';

final ScoreBloc scoreBloc = ScoreBloc();
final GameFlowBloc gameFlowBloc = GameFlowBloc();

class InitSnake extends StatelessWidget {
  InitSnake({
    super.key,
  });

  final Game game = SnakeGame(scoreBloc: scoreBloc, gameFlowBloc: gameFlowBloc);

  static const instructionsOverlay = 'instructionsOverlay';
  static const scoreOverlay = 'scoreOverlay';
  static const gameOverOverlay = 'gameOverOverlay';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'PressStart2P',
      ),
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ScoreBloc>(
            create: (BuildContext context) => scoreBloc,
          ),
        ],
        child: GameWidget(
          game: game,
          overlayBuilderMap: <String, Widget Function(BuildContext, Game)>{
            instructionsOverlay: (context, game) => InstructionsOverlay(game),
            gameOverOverlay: (context, game) => GameOverOverlay(game),
            scoreOverlay: (context, game) => ScoreOverlay(game),
          },
          initialActiveOverlays: const [
            scoreOverlay,
          ],
        ),
      ),
    );
  }
}
