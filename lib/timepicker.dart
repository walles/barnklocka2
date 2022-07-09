import 'dart:math';

class TimePicker {
  final _random = Random();

  // Quarters, but not ones covered by easier kinds
  static const _quarters = [15, 45];

  // Five minute intervals, but not ones covered by easier kinds
  static const _fivers = [5, 10, 20, 25, 35, 40, 50, 55];

  /// `difficulty` is 1-5 with 5 being the most difficult
  DateTime createTimestampAtDifficulty(int difficulty) {
    switch (difficulty) {
      case 1:
        return DateTime(2000, 1, 1, _random.nextInt(24), 0);
      case 2:
        return DateTime(2000, 1, 1, _random.nextInt(24), 30);
      case 3:
        return DateTime(2000, 1, 1, _random.nextInt(24),
            _quarters[_random.nextInt(_quarters.length)]);
      case 4:
        return DateTime(2000, 1, 1, _random.nextInt(24),
            _fivers[_random.nextInt(_fivers.length)]);
      case 5:
        int minutes = 0;
        while (minutes % 5 == 0) {
          minutes = _random.nextInt(60);
        }
        return DateTime(2000, 1, 1, _random.nextInt(24), minutes);

      default:
        throw ('Internal error making up a time for difficulty $difficulty');
    }
  }
}
