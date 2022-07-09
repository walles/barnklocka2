class GameState {
  static const _startScreenNumber = 0;
  static const _questionsPerGame = 2; // FIXME: I think 10 is a good number

  /// Question number `0` means we're on the start screen
  int _questionNumberOneBased = _startScreenNumber;

  /// Otherwise we're inside of a game
  bool shouldShowStartScreen() {
    return _questionNumberOneBased < 1;
  }

  // FIXME: Maybe this should take a right / wrong boolean?
  void questionAnswered() {
    assert(_questionNumberOneBased >= 1);
    _questionNumberOneBased++;

    if (_questionNumberOneBased > _questionsPerGame) {
      // Back to the start screen
      _questionNumberOneBased = _startScreenNumber;
    }
  }

  void start() {
    assert(_questionNumberOneBased == _startScreenNumber);
    _questionNumberOneBased = 1;
  }
}
