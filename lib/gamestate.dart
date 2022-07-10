import 'package:barnklocka2/gamestats.dart';
import 'package:barnklocka2/timepicker.dart';
import 'package:barnklocka2/toplist.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class GameState {
  static const _startScreenNumber = 0;
  static const questionsPerGame = kDebugMode ? 2 : 5;
  static const _persistentTopListKey = 'toplist';

  // How difficult the timestamps should be at each round
  static const difficulties = [1, 2, 3, 4, 5];

  final _timePicker = TimePicker();

  /// The current question for the user
  DateTime? _timestamp;

  DateTime? _gameStartTime;
  int _correctOnFirstAttempt = 0;
  bool _lastAnswerWasRight = true;

  final TopList _toplist = _createTopList();
  static TopList _createTopList() {
    String? serialized = GetStorage().read(_persistentTopListKey);
    if (serialized == null) {
      return TopList(5);
    }

    return TopList.deserialize(serialized);
  }

  /// Question number `0` means we're on the start screen
  int _questionNumberOneBased = _startScreenNumber;

  /// Otherwise we're inside of a game
  bool get shouldShowStartScreen {
    return _questionNumberOneBased < 1;
  }

  void start() {
    assert(_questionNumberOneBased == _startScreenNumber);

    _questionNumberOneBased = 1;
    _gameStartTime = DateTime.now();
    _correctOnFirstAttempt = 0;
    _lastAnswerWasRight = true;
    _timestamp = null;
  }

  DateTime get timestamp {
    _timestamp ??= _timePicker
        .createTimestampAtDifficulty(difficulties[_questionNumberOneBased - 1]);
    return _timestamp!;
  }

  /// Returns `true` if the answer was correct, `false` otherwise
  bool registerAnswer(String answer, Function onCorrect) {
    assert(_questionNumberOneBased >= 1);

    if (!isValidRendering(answer, timestamp)) {
      _lastAnswerWasRight = false;
      return false;
    }

    // Handle getting a correct answer
    if (_lastAnswerWasRight) {
      _correctOnFirstAttempt++;
    }
    _lastAnswerWasRight = true;

    _timestamp = null;
    _questionNumberOneBased++;
    if (_questionNumberOneBased > questionsPerGame) {
      // Back to the start screen
      _questionNumberOneBased = _startScreenNumber;
      _toplist.add(GameStats(
          DateTime.now().difference(_gameStartTime!), _correctOnFirstAttempt));
      GetStorage().write(_persistentTopListKey, _toplist.serialize());
    }

    onCorrect();

    return true;
  }

  TopList get topList {
    return _toplist;
  }
}

/// Checks whether the rendering ("1234" for example) is a valid rendering of
/// the timestamp's hours and minutes.
@visibleForTesting
bool isValidRendering(String rendering, DateTime timestamp) {
  final twoDigits = NumberFormat('00');

  if (rendering.length == 3) {
    rendering = '0$rendering';
  }

  final correct =
      '${twoDigits.format(timestamp.hour)}${twoDigits.format(timestamp.minute)}';

  return rendering == correct;
}
