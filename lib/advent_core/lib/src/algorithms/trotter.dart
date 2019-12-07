import 'dart:collection';

class Permutations<S> with IterableMixin<List<S>> {
  int _r;
  final List<S> _items;
  int _length;

  Permutations(this._items, [int r]) {
    _r = r ??
        _items.length; // r doesn't matter, haven't implemented taking subsets
    _length = _nPr(_items.length, _r);
  }

  _nPr(int n, int r) => _factorial(n) ~/ _factorial(n - r);

  int _factorial(int n) => n == 0 ? 1 : n * _factorial(n - 1);

  @override
  Iterator<List<S>> get iterator => PermutationIterator<S>(_items, _length);
}

class PermutationIterator<S> extends Iterator<List<S>> {
  PermList<S> _permList;
  int _length;
  List<S> _current;
  bool lastPerm = false;

  PermutationIterator(List<S> items, this._length) {
    _length = items.length;
    var hashSet = HashSet<PermItem<S>>();

    for (var i = 0; i < items.length; i++) {
      hashSet.add(PermItem(i, items[i]));
    }

    _permList = PermList(hashSet);
    _current = _permList.current;
  }

  @override
  List<S> get current => _current;

  @override
  bool moveNext() {
    if (lastPerm) return false;
    _current = _permList.current;
    if (_permList.mobileCount == 0) {
      return lastPerm = true;
    } else {
      _permList.swap();
      _permList.changeDirections();
      _permList.setCurrentMobile();
      return !lastPerm;
    }
  }
}

class PermList<S> {
  final HashSet<PermItem<S>> _items;
  PermItem _currentMobile;

  PermList(this._items) {
    setCurrentMobile();
  }

  PermItem operator [](int index) {
    return _items.singleWhere((i) => i._cPos == index, orElse: () => null);
  }

  swap() {
    if (_currentMobile == null) return;
    _currentMobile.swapWith(_getNext());
  }

  setCurrentMobile() {
    for (var pi in _items.toList()) {
      var next = this[pi._cPos + pi._dir];
      pi._mobile = next != null && pi._iPos > next._iPos;
    }

    var mobileItems = _items.where((i) => i.isMobile());
    _currentMobile = mobileItems.isNotEmpty
        ? mobileItems.reduce((i1, i2) => i1 > i2 ? i1 : i2)
        : null;
  }

  changeDirections() {
    for (var item in _items) {
      if (item > _currentMobile) item.switchDirection();
    }
  }

  PermItem _getNext() {
    return this[_currentMobile._cPos + _currentMobile._dir];
  }

  int get mobileCount =>
      _items.fold<int>(0, (c, i) => i.isMobile() ? c + 1 : c);

  List<S> get current => (_items.toList()..sort()).map((i) => i.value).toList();
}

class PermItem<S> implements Comparable<PermItem> {
  final int _iPos;
  int _cPos;
  int _dir = -1;
  bool _mobile;
  S value;

  PermItem(this._iPos, this.value) {
    _cPos = _iPos;
  }

  isMobile() => _mobile;
  switchDirection() => _dir *= -1;

  swapWith(PermItem other) {
    var cPos = _cPos;
    _cPos = other._cPos;
    other._cPos = cPos;
  }

  operator ==(dynamic other) => other is PermItem && _iPos == other._iPos;
  operator >(PermItem other) => _iPos > other._iPos;

  @override
  int compareTo(PermItem other) =>
      _cPos == other._cPos ? 0 : _cPos > other._cPos ? 1 : -1;
}
