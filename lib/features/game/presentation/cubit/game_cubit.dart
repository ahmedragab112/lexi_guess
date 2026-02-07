import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexi_guess/core/network/audio_service.dart';
import '../../data/models/level_entities.dart';
import '../../data/repositories/level_repository.dart';
import 'game_state.dart';
import '../utils/game_helpers.dart';

class GameCubit extends Cubit<GameState> {
  final LevelRepository _repository;
  Timer? _timer;

  GameCubit(this._repository) : super(const GameState());

  Future<void> loadLevel(int levelNumber) async {
    emit(
      state.copyWith(
        status: GameStatus.loading,
        foundWords: {},
        currentInput: '',
        hintsRemaining: 3,
      ),
    );
    try {
      final puzzle = await _repository.getLevel(levelNumber);
      emit(
        state.copyWith(
          status: GameStatus.playing,
          currentPuzzle: puzzle,
          timeLeft: puzzle.timeLimitSeconds,
        ),
      );
      _startTimer();
    } catch (e) {
      emit(
        state.copyWith(status: GameStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft <= 0) {
        _timer?.cancel();
        emit(state.copyWith(status: GameStatus.lost));
      } else {
        emit(state.copyWith(timeLeft: state.timeLeft - 1));
      }
    });
  }

  void addLetter(String letter) {
    if (state.status != GameStatus.playing) return;
    emit(
      state.copyWith(currentInput: state.currentInput + letter.toUpperCase()),
    );
    AudioService.playTap();
  }

  void clearInput() {
    emit(state.copyWith(currentInput: ''));
  }

  void useHint() {
    if (state.status != GameStatus.playing || state.hintsRemaining <= 0) return;

    final puzzle = state.currentPuzzle;
    if (puzzle == null) return;

    // Find first word not found
    final unfound = puzzle.targetWords
        .where((word) => !state.foundWords.contains(word))
        .toList();
    if (unfound.isEmpty) return;

    final firstWord = unfound.first;
    final hint = 'A word starts with "${firstWord[0]}"';

    emit(
      state.copyWith(
        hintsRemaining: state.hintsRemaining - 1,
        errorMessage: 'HINT: $hint',
      ),
    );
    // Clear the message after a delay so it can be triggered again
    Future.delayed(const Duration(seconds: 2), () {
      if (!isClosed) emit(state.copyWith(errorMessage: null));
    });
  }

  void submitInput() async {
    if (state.status != GameStatus.playing) return;
    final input = state.currentInput;
    if (input.isEmpty) return;

    final puzzle = state.currentPuzzle;
    if (puzzle == null) return;

    if (puzzle.targetWords.contains(input) &&
        !state.foundWords.contains(input)) {
      final updatedFound = Set<String>.from(state.foundWords)..add(input);
      emit(state.copyWith(foundWords: updatedFound, currentInput: ''));

     await  AudioService.playCorrect();

      await _repository.saveDiscoveredWord(
        DiscoveredWord(
          word: input,
          discoveredAt: DateTime.now(),
          levelFound: puzzle.level,
        ),
      );

      if (updatedFound.length == puzzle.targetWords.length) {
        _timer?.cancel();

        // Calculate Stars using GameHelpers
        final timeTaken = puzzle.timeLimitSeconds - state.timeLeft;
        final stars = GameHelpers.calculateStars(
          timeTaken,
          puzzle.timeLimitSeconds,
        );

        emit(state.copyWith(status: GameStatus.won, starsEarned: stars));
     await   AudioService.playWin();
        final allProgress = await _repository.getAllProgress();
        final existing = allProgress
            .where((p) => p.levelNumber == puzzle.level)
            .toList();

        bool shouldSave = true;
        if (existing.isNotEmpty) {
          if (existing.first.starsEarned >= stars) {
            shouldSave = false;
          }
        }

        if (shouldSave) {
          await _repository.saveProgress(
            LevelProgress(
              levelNumber: puzzle.level,
              isCompleted: true,
              starsEarned: stars,
              completedAt: DateTime.now(),
            ),
          );
        }
      }
    } else {
      emit(state.copyWith(currentInput: ''));
      // Could add a "shake" effect here
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
