import 'package:equatable/equatable.dart';

class WordPuzzle extends Equatable {
  final int level;
  final List<String> availableLetters;
  final List<String> targetWords;
  final int timeLimitSeconds;

  const WordPuzzle({
    required this.level,
    required this.availableLetters,
    required this.targetWords,
    this.timeLimitSeconds = 60,
  });

  @override
  List<Object?> get props => [
    level,
    availableLetters,
    targetWords,
    timeLimitSeconds,
  ];
}
