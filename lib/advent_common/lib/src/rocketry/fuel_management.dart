class FuelCircuit {
  final _points = Set<FuelPoint>();
  final origin = FuelPoint(0, 0, null);
  Set<FuelPoint> _intersections = Set();

  FuelCircuit();

  addPoint(FuelPoint point) => _points.add(point);
  removePoint(FuelPoint point) => _points.remove(point);

  addPath(String path, int wire) {
    var vectors = path.split(',');
    _points.add(origin);
    var previousOrigin = origin;

    for (var i = 0; i < vectors.length; i++) {
      var vector = FuelVector.fromString(vectors[i], previousOrigin, wire);
      var newPoints = vector.getPoints();
      _intersections.addAll(newPoints
          .where((point) => _points.any((other) => point.intersects(other))));
      _points.addAll(newPoints);
      previousOrigin = vector.endPoint;
    }
  }

  addVector(FuelVector vector) {
    _points.addAll(vector.getPoints());
  }

  List<FuelPoint> getIntersections() {
    return _intersections.toList();
  }

  FuelPoint getClosestIntersection() {
    var intersections = getIntersections();
    return intersections.where((inter) => inter.wire == 1).reduce(
        (interA, interB) =>
            origin.distanceTo(interA) < origin.distanceTo(interB)
                ? interA
                : interB);
  }

  List<FuelPoint> getPoints() {
    return _points.toList();
  }

  printCircuit() {
    var maxY = _upBound.y + 1;
    var maxX = _rightBound.x + 1;
    var minY = _downBound.y - 1;
    var minX = _leftBound.x - 1;

    var lines = [];
    for (var y = maxY; y >= minY; y--) {
      var line = [];
      for (var x = minX; x <= maxX; x++) {
        if (x == 0 && y == 0) {
          line.add('o');
          continue;
        }

        var points = _points.where((point) => point.x == x && point.y == y);
        if (points.length > 0) {
          line.add(points.length > 1 ? 'X' : '*');
        } else {
          line.add('.');
        }
      }

      lines.add(line.join());
    }

    print(lines.join('\n'));
  }

  get _upBound =>
      _points.reduce((pointA, pointB) => pointA.y > pointB.y ? pointA : pointB);
  get _downBound =>
      _points.reduce((pointA, pointB) => pointA.y < pointB.y ? pointA : pointB);
  get _leftBound =>
      _points.reduce((pointA, pointB) => pointA.x < pointB.x ? pointA : pointB);
  get _rightBound =>
      _points.reduce((pointA, pointB) => pointA.x > pointB.x ? pointA : pointB);
}

class FuelPoint {
  final int x;
  final int y;
  final int wire;

  FuelPoint(this.x, this.y, this.wire);

  bool operator ==(dynamic other) =>
      other is FuelPoint && x == other.x && y == other.y && wire == other.wire;

  distanceTo(FuelPoint other) {
    var dx = x - other.x;
    var dy = x - other.y;
    return dx.abs() + dy.abs();
  }

  String toString() => 'FuelPoint($x, $y, $wire)';

  bool intersects(FuelPoint other) {
    return x == other.x && y == other.y && wire != other.wire;
  }
}

class FuelVector {
  final FuelPoint origin;
  final String direction;
  final int magnitude;
  FuelPoint endPoint;

  FuelVector(this.origin, this.direction, this.magnitude, {int wire}) {
    var dFactor = (direction == 'D' || direction == 'L') ? -1 : 1;
    var endX, endY;

    if (direction == 'U' || direction == 'D') {
      endY = origin.y + magnitude * dFactor;
    } else {
      endX = origin.x + magnitude * dFactor;
    }

    endPoint =
        FuelPoint(endX ?? origin.x, endY ?? origin.y, wire ?? origin.wire);
  }

  static FuelVector fromString(String vectorString, FuelPoint origin,
      [int wire]) {
    return FuelVector(
        origin, vectorString[0], int.parse(vectorString.substring(1)),
        wire: wire);
  }

  Set<FuelPoint> getPoints() {
    var points = Set<FuelPoint>();
    var magX = 0, magY = 0;
    var isNeg = direction == 'D' || direction == 'L';

    if (direction == 'U' || direction == 'D') {
      magY = 1;
    } else {
      magX = 1;
    }

    for (var i = isNeg ? -1 : 1; i.abs() <= magnitude; isNeg ? i-- : i++) {
      points.add(
          FuelPoint(origin.x + i * magX, origin.y + i * magY, endPoint.wire));
    }

    return points;
  }
}
