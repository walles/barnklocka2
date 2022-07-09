class GameStats implements Comparable<GameStats> {
  final Duration duration;
  final int correctOnFirstAttempt;

  GameStats(this.duration, this.correctOnFirstAttempt);

  @override
  int compareTo(GameStats other) {
    if (correctOnFirstAttempt > other.correctOnFirstAttempt) {
      // this is ordered before other, return a negative integer
      return -1;
    } else if (correctOnFirstAttempt < other.correctOnFirstAttempt) {
      // this is ordered after other, return a positive integer
      return 1;
    }

    if (duration < other.duration) {
      // this is ordered before other, return a negative integer
      return -1;
    } else if (duration > other.duration) {
      // this is ordered after other, return a positive integer
      return 1;
    }

    return 0;
  }

  @override
  String toString() {
    return '[$correctOnFirstAttempt, $duration]';
  }
}
