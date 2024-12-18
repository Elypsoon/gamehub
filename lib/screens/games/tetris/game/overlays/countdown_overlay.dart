import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:game_hub/screens/games/tetris/game/components/digital_number.dart';
import 'package:game_hub/screens/games/tetris/game/tetris_game.dart';

class CountdownOverlay extends StatefulWidget {
  static String keyOverlay = "countdownOverlay";
  final TetrisGame game;
  const CountdownOverlay({super.key, required this.game});

  @override
  State<CountdownOverlay> createState() => _CountdownOverlayState();
}

class _CountdownOverlayState extends State<CountdownOverlay> {
  int _countdown = 3;

  @override
  void initState() {
    super.initState();
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (timer.tick == 3) {
          timer.cancel();
          
          widget.game.endCountDown();
        } else {
          setState(() {
            _countdown--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 50,
                child: DigitalNumber(
                    value: _countdown,
                    height: 100,
                    color: Colors.black,
                    padLeft: 0)),
          ],
        ),
      ),
    );
  }
  
}
