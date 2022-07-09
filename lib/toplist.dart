import 'package:barnklocka2/gamestats.dart';

class TopList {
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

  List<GameStats> list() {
    return _list;
  }

  /// Returns an index into `list()`
  int mostRecentEntry() {
    return _mostRecentEntry;
  }
}
