class Diff {
  String a;
  List<int> _explodeA;
  String b;
  List<int> _explodeB;
  int diffCount = 0;
  String matchedString = '';

  Diff(String this.a, String this.b) {
    _explodeA = a.codeUnits;
    _explodeB = b.codeUnits;

    _calcDiff();
    _matchStrings();
  }

  _calcDiff() {
    for (var i = 0; i < _explodeA.length; i++) {
      if (_explodeA[i] != _explodeB[i]) diffCount++;
    }
  }

  _matchStrings() {
    var merged = new List<int>();

    for (var i = 0; i < _explodeA.length; i++) {
      if (_explodeA[i] == _explodeB[i]) {
        merged.add(_explodeA[i]);
      }
    }

    matchedString = merged.map((charCode) => new String.fromCharCode(charCode)).join();
  }
}