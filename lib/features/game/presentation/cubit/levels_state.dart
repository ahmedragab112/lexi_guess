import 'package:equatable/equatable.dart';
import 'package:lexi_guess/features/game/data/models/level_entities.dart';

enum LevelsStatus { initial, loading, loaded, error }

class LevelsState extends Equatable {
  final LevelsStatus status;
  final List<LevelProgress> progress;
  final String? errorMessage;

  final int totalLevels;

  const LevelsState({
    this.status = LevelsStatus.initial,
    this.progress = const [],
    this.totalLevels = 0,
    this.errorMessage,
  });

  bool get hasData => totalLevels > 0;

  int get latestUnlockedLevel {
    if (progress.isEmpty) return 1;
    final completed = progress
        .where((p) => p.isCompleted)
        .map((p) => p.levelNumber)
        .toList();
    if (completed.isEmpty) return 1;
    // Find the max level number and add 1
    int maxLevel = 0;
    for (var level in completed) {
      if (level > maxLevel) maxLevel = level;
    }
    return maxLevel + 1;
  }

  LevelsState copyWith({
    LevelsStatus? status,
    List<LevelProgress>? progress,
    int? totalLevels,
    String? errorMessage,
  }) {
    return LevelsState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      totalLevels: totalLevels ?? this.totalLevels,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, progress, totalLevels, errorMessage];
}
