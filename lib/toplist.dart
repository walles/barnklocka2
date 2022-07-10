import 'package:barnklocka2/gamestats.dart';

/// Retain a toplist of at most `size` entries. The most recent entry will
/// always be preserved, even if it is the worst. Its index can be retrieved
/// using `mostRecentEntry()`.
class TopList {
  static const defaultSize = 5;
  final int size;

  /// An index into `_list`
  int _mostRecentEntry = 0;

  final List<GameStats> _list = [];

  TopList(this.size);

  void add(GameStats stats) {
    _list.add(stats);
    _list.sort();

    _mostRecentEntry = -1;
    for (int i = 0; i < _list.length; i++) {
      if (_list[i] == stats) {
        _mostRecentEntry = i;
        break;
      }
    }
    assert(_mostRecentEntry != -1);

    if (_list.length <= size) {
      // No need to evict anything
      return;
    }

    if (_mostRecentEntry == _list.length - 1) {
      // Evict the next to last entry since the last one i the most recent one,
      // and we should always keep that
      _list.removeAt(_list.length - 2);
      _mostRecentEntry--;
      return;
    }

    _list.removeLast();
  }

  List<GameStats> get list {
    return _list;
  }

  /// Returns an index into `list()`
  int get mostRecentEntry {
    return _mostRecentEntry;
  }

  bool get isEmpty {
    return _list.isEmpty;
  }

  String serialize() {
    String serialized = '$size';

    for (final entry in _list) {
      serialized +=
          ' ${entry.correctOnFirstAttempt} ${entry.duration.inMilliseconds}';
    }

    return serialized;
  }

  /// Note that after deserialization, `mostRecentEntry` will be set to -1. I
  /// think having that value being correct is only important just after a game,
  /// not after coming back at some later point.
  static TopList deserialize(String serialized) {
    var strings = serialized.split(' ');
    if (strings.isEmpty) {
      return TopList(defaultSize);
    }
    if (strings.length % 2 != 1) {
      // Expect one length number at the beginning, then pairs of correct
      // answers and durations. If we have an even number of entries, then
      // that's something else.
      return TopList(defaultSize);
    }

    List<int> numbers = [];
    for (final string in strings) {
      final number = int.parse(string);
      if (number.isNaN) {
        return TopList(defaultSize);
      }

      numbers.add(number);
    }

    TopList topList = TopList(numbers[0]);
    for (int i = 1; i < numbers.length; i += 2) {
      int correctOnFirstAttempt = numbers[i];
      int milliseconds = numbers[i + 1];
      topList.add(GameStats(
          Duration(milliseconds: milliseconds), correctOnFirstAttempt));
    }

    topList._mostRecentEntry = -1;

    return topList;
  }
}
