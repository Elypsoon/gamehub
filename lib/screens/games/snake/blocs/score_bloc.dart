import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ScoreEvent {}

class IncrementScore extends ScoreEvent {}

class ResetScore extends ScoreEvent {}

class ScoreBloc extends Bloc<ScoreEvent, int> {
  ScoreBloc() : super(0) {
    on<IncrementScore>(
      (event, emit) {
        final newScore = state + 1;
        emit(newScore);
      },
    );
    on<ResetScore>(
      (event, emit) {
        emit(0);
      },
    );
  }
}
