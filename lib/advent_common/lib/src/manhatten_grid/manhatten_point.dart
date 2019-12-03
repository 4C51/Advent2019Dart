import 'dart:math';

class ManhattenPoint extends Point {
  ManhattenPoint(num x, num y) : super(x, y);

  @override
  double distanceTo(Point other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return dx.abs() + dy.abs();
  }
}
