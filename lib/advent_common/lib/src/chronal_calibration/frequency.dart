/// Adjust frequencies with ease!
class Frequency {
  num start;
  num current;
  Set<num> _seen;
  List<num> _duplicates;
  num duplicateIterations = 0;

  /// Creates a [Frequency] object
  Frequency([num this.start = 0]) {
    current = start;
    _seen = new Set();
    _duplicates = new List();
  }

  /// Increase frequency by [val]
  increase(num val) {
    current += val;
  }

  /// Decrease frequency by [val]
  decrease(num val) {
    current -= val;
  }

  /// Adjust the frequency by [adjustment] string, e.g. +5
  adjust(String adjustment) {
    var sign = adjustment[0];
    var scalar = int.parse(adjustment.substring(1));
    sign == '+' ? increase(scalar) : decrease(scalar);

    return current;
  }

  /// Calls [adjust] on a sequence of [adjustments]
  adjustSequence(List<String> adjustments) {
    adjustments.forEach((adjustment) => adjust(adjustment));

    return current;
  }

  _dupeCheck() {
    if (_seen.contains(current)) {
      _duplicates.add(current);
    } else {
      _seen.add(current);
    }
  }

  /**
   * Runs an [adjustSequence] repeatedly looking for duplicates
   * 
   * [stopOn] specifies how many duplicates it should find before stopping
   * [maxIter] specifies a maximum number of loops of [adjustments] before giving up
   * */
  circularFindDuplicates(List<String> adjustments, [num stopOn = 1, num maxIter = 10]) {
    duplicateIterations = 0;

    for (var i = 0; i < maxIter; i++) {
      for (var adjustment in adjustments) {
        adjust(adjustment);
        _dupeCheck();
        
        if (_duplicates.length >= stopOn) {
          duplicateIterations = i;

          return _duplicates;
        }
      }
    }

    return _duplicates;
  }
}