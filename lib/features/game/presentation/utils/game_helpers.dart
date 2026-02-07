/// Helper utilities for game-related operations
class GameHelpers {
  /// Format seconds into MM:SS format
  static String formatTime(int seconds) {
    if (seconds < 0) return '0:00';
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  static int calculateStars(int timeTaken, int timeLimit) {
    if (timeLimit <= 0) return 1;

    if (timeTaken < timeLimit * 0.2) {
      return 5;
    } else if (timeTaken < timeLimit * 0.4) {
      return 4;
    } else if (timeTaken < timeLimit * 0.6) {
      return 3;
    } else if (timeTaken < timeLimit * 0.8) {
      return 2;
    } else {
      return 1;
    }
  }

  /// Calculate score based on words found
  static int calculateScore(int wordsFound) {
    return wordsFound * 100;
  }

  /// Get feedback comment based on stars earned
  static String getFeedbackComment(int stars) {
    if (stars == 5) return 'EXCELLENT!';
    if (stars == 4) return 'GREAT JOB!';
    if (stars == 3) return 'GOOD WORK';
    if (stars == 2) return 'NICE EFFORT';
    return 'KEEP TRYING';
  }
}
