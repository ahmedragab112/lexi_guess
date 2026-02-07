class ResultRouteArgs {
  final int level;
  final int stars;
  final int timeTaken;
  final List<String> foundWords;
  final int totalWords;

  const ResultRouteArgs({
    required this.level,
    required this.stars,
    required this.timeTaken,
    required this.foundWords,
    required this.totalWords,
  });
}
