import 'package:objectbox/objectbox.dart';

@Entity()
class LevelProgress {
  @Id()
  int id = 0;

  int levelNumber;
  bool isCompleted;
  int starsEarned;
  DateTime? completedAt;

  LevelProgress({
    required this.levelNumber,
    this.isCompleted = false,
    this.starsEarned = 0,
    this.completedAt,
  });
}

@Entity()
class DiscoveredWord {
  @Id()
  int id = 0;

  String word;
  DateTime discoveredAt;
  int levelFound;

  DiscoveredWord({
    required this.word,
    required this.discoveredAt,
    required this.levelFound,
  });
}
