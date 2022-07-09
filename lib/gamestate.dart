import 'package:barnklocka2/timepicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GameState {
  static const _startScreenNumber = 0;
  static const _questionsPerGame = 2; // FIXME: I think 10 is a good number

  final _timePicker = TimePicker();

  DateTime? _timestamp;

  /// Question number `0` means we're on the start screen
  int _questionNumberOneBased = _startScreenNumber;

  /// Otherwise we're inside of a game
  bool shouldShowStartScreen() {
    return _questionNumberOneBased < 1;
  }

  void start() {
    assert(_questionNumberOneBased == _startScreenNumber);
    _questionNumberOneBased = 1;
  }

  DateTime getTimestamp() {
    _timestamp ??= _timePicker.createRandomTimestamp();
    return _timestamp!;
  }

  /// Returns `true` if the answer was correct, `false` otherwise
  bool registerAnswer(String answer, Function onCorrect) {
    assert(_questionNumberOneBased >= 1);

    if (isValidRendering(answer, getTimestamp())) {
      _timestamp = _timePicker.createRandomTimestamp();

      _questionNumberOneBased++;
      if (_questionNumberOneBased > _questionsPerGame) {
        // Back to the start screen
        _questionNumberOneBased = _startScreenNumber;
      }

      onCorrect();

      return true;
    }

    // FIXME: Register the wrong answer somehow
    return false;
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
