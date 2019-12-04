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
      if (_doubleRule(i) && _increasingRule(i) && _strictDoubleRule(i))
        possiblePasswords.add(i);
    }

    return possiblePasswords.length;
  }

  testPassword(int guess) {
    return _doubleRule(guess) &&
        _increasingRule(guess) &&
        _strictDoubleRule(guess);
  }

  _doubleRule(int guess) {
    if (!doubleRule) return true;
    return RegExp(r'(.)\1').hasMatch(guess.toString());
  }

  _strictDoubleRule(int guess) {
    if (!strictDoubleRule) return true;
    var chars = guess.toString().split('').map((c) => int.parse(c)).toList();
    var hasDouble = false;
    var lastChar = 0;
    var groupCount = 1;

    for (var i = 0; i < chars.length; i++) {
      if (lastChar != chars[i] && groupCount == 2) {
        hasDouble = true;
        break;
      }

      if (lastChar == chars[i])
        groupCount++;
      else
        groupCount = 1;
      lastChar = chars[i];
    }

    if (groupCount == 2) hasDouble = true;

    return hasDouble;
  }

  _increasingRule(int guess) {
    if (!increasingRule) return true;
    var chars = guess.toString().split('').map((c) => int.parse(c)).toList();
    var minimum = 0;
    for (var i = 0; i < chars.length; i++) {
      if (chars[i] < minimum) {
        return false;
      }
      minimum = chars[i];
    }
    return true;
  }
}
