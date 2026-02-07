import 'package:equatable/equatable.dart';
import 'package:lexi_guess/features/game/data/models/word_puzzle.dart';

enum GameStatus { initial, loading, playing, won, lost, error }

class GameState extends Equatable {
  final WordPuzzle? currentPuzzle;
  final GameStatus status;
  final Set<String> foundWords;
  final String currentInput;
  final int timeLeft;
  final int hintsRemaining;
  final String? errorMessage;
  final int starsEarned;

  const GameState({
    this.currentPuzzle,
    this.status = GameStatus.initial,
    this.foundWords = const {},
    this.currentInput = '',
    this.timeLeft = 0,
    this.hintsRemaining = 3,
    this.errorMessage,
    this.starsEarned = 0,
  });

  GameState copyWith({
    WordPuzzle? currentPuzzle,
    GameStatus? status,
    Set<String>? foundWords,
    String? currentInput,
    int? timeLeft,
    int? hintsRemaining,
    String? errorMessage,
    int? starsEarned,
  }) {
    return GameState(
      currentPuzzle: currentPuzzle ?? this.currentPuzzle,
      status: status ?? this.status,
      foundWords: foundWords ?? this.foundWords,
      currentInput: currentInput ?? this.currentInput,
      timeLeft: timeLeft ?? this.timeLeft,
      hintsRemaining: hintsRemaining ?? this.hintsRemaining,
      errorMessage: errorMessage,
      starsEarned: starsEarned ?? this.starsEarned,
    );
  }

  @override
  List<Object?> get props => [
    currentPuzzle,
    status,
    foundWords,
    currentInput,
    timeLeft,
    hintsRemaining,
    errorMessage,
    starsEarned,
  ];
}
