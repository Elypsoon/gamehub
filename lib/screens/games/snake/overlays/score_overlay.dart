import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_hub/screens/games/snake/blocs/score_bloc.dart';
import 'package:game_hub/screens/games/snake/game_config.dart';

class ScoreOverlay extends StatelessWidget {
  const ScoreOverlay(this.game, {super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final positionGrid = (
      x: (mediaQuery.width - GameConfig.columns * GameConfig.sizeCell) / 2,
      y: (mediaQuery.height - GameConfig.rows * GameConfig.sizeCell) / 2,
    );

    return Positioned(
      top: positionGrid.y - GameConfig.sizeCell - 10,
      left: positionGrid.x,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: SizedBox(
              height: 30,
              child: Image.asset(
                'assets/images/score.png',
              ),
            ),
          ),
          Text(
            'x ${context.watch<ScoreBloc>().state}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                ),
          ),
        ],
      ),
    );
  }
}
