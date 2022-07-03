import 'dart:math';

class TimePicker {
  final _random = Random();

  static const _kinds = [
    1, 1, 1, 1, 1, // whole hours
    2, 2, 2, 2, // half hours
    3, 3, 3, // quarters
    4, 4, // five-minute intervals
    5, // one-minute intervals
  ];

  // Quarters, but not ones covered by easier kinds
  static const _quarters = [15, 45];

  // Five minute intervals, but not ones covered by easier kinds
  static const _fivers = [5, 10, 20, 25, 35, 40, 50, 55];

  DateTime createRandomTimestamp() {
    final kind = _kinds[_random.nextInt(_kinds.length)];

    switch (kind) {
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
        throw ('Internal error making up a time');
    }
  }
}
