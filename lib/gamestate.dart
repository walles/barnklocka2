import 'package:barnklocka2/gamestats.dart';
import 'package:barnklocka2/timepicker.dart';
import 'package:barnklocka2/toplist.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class GameState {
  static const _startScreenNumber = 0;
  static const questionsPerGame = kDebugMode ? 2 : 10;

  final _timePicker = TimePicker();

  /// The current question for the user
  DateTime? _timestamp;

  DateTime? _gameStartTime;
  int _correctOnFirstAttempt = 0;
  bool _lastAnswerWasRight = true;

  final TopList _toplist = TopList(5);

  /// Question number `0` means we're on the start screen
  int _questionNumberOneBased = _startScreenNumber;

  /// Otherwise we're inside of a game
  bool shouldShowStartScreen() {
    return _questionNumberOneBased < 1;
  }

  void start() {
    assert(_questionNumberOneBased == _startScreenNumber);

    _questionNumberOneBased = 1;
    _gameStartTime = DateTime.now();
    _correctOnFirstAttempt = 0;
    _lastAnswerWasRight = true;
  }

  DateTime getTimestamp() {
    _timestamp ??= _timePicker.createRandomTimestamp();
    return _timestamp!;
  }

  /// Returns `true` if the answer was correct, `false` otherwise
  bool registerAnswer(String answer, Function onCorrect) {
    assert(_questionNumberOneBased >= 1);

    if (!isValidRendering(answer, getTimestamp())) {
      _lastAnswerWasRight = false;
      return false;
    }

    // Handle getting a correct answer
    if (_lastAnswerWasRight) {
      _correctOnFirstAttempt++;
    }
    _lastAnswerWasRight = true;

    _timestamp = _timePicker.createRandomTimestamp();
    _questionNumberOneBased++;
    if (_questionNumberOneBased > questionsPerGame) {
      // Back to the start screen
      _questionNumberOneBased = _startScreenNumber;
      _toplist.add(GameStats(
          DateTime.now().difference(_gameStartTime!), _correctOnFirstAttempt));
    }

    onCorrect();

    return true;
  }

  TopList topList() {
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
