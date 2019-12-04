class Password {
  int lowerBound = 111111;
  int upperBound = 999999;
  Set<int> possiblePasswords = Set<int>();

  bool doubleRule = true;
  bool increasingRule = true;
  bool strictDoubleRule = false;

  setRange(String range) {
    var bounds = range.split('-');
    lowerBound = int.parse(bounds[0]);
    upperBound = int.parse(bounds[1]);
  }

  countCandidates() {
    possiblePasswords.clear();

    for (var i = lowerBound; i <= upperBound; i++) {
      if (_increasingRule(i) && _strictDoubleRule(i) && _doubleRule(i))
        possiblePasswords.add(i);
    }

    return possiblePasswords.length;
  }

  testPassword(int guess) {
    return _increasingRule(guess) &&
        _strictDoubleRule(guess) &&
        _doubleRule(guess);
  }

  _doubleRule(int guess) {
    if (!doubleRule) return true;
    return RegExp(r'(.)\1').hasMatch(guess.toString());
  }

  _strictDoubleRule(int guess) {
    if (!strictDoubleRule) return true;

    var chars = guess.toString().split('').map((c) => int.parse(c)).toList();

    for (var i = 0; i < chars.length; i++) {
      if (chars.lastIndexOf(chars[i]) - chars.indexOf(chars[i]) == 1)
        return true;
    }

    return false;
  }

  _increasingRule(int guess) {
    if (!increasingRule) return true;

    return int.parse((guess.toString().split('')..sort()).join()) == guess;
  }
}
