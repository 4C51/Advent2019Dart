class FuelCircuit {
  final _vectors = Set<FuelVector>();
  final origin = FuelPoint(0, 0);

  FuelCircuit();

  addPath(String path, int wire) {
    var vectors = path.split(',');
    var previousOrigin = origin;

    for (var i = 0; i < vectors.length; i++) {
      var vector = FuelVector.fromString(vectors[i], previousOrigin, wire);
      _vectors.add(vector);
      previousOrigin = vector.endPoint;
    }
  }

  List<FuelPoint> getIntersections() {
    var ints = List<FuelPoint>();
    var intersections = _vectors.fold<List<FuelPoint>>(ints, (ints, vector) {
      ints.addAll(vector.intersections(_vectors));
      return ints;
    }).toSet().toList();
    intersections.removeWhere((intersection) => intersection == null);
    return intersections;
  }

  FuelPoint getClosestIntersection() {
    var intersections = getIntersections();
    return intersections.reduce(
        (interA, interB) =>
            origin.distanceTo(interA) < origin.distanceTo(interB)
                ? interA
                : interB);
  }
}

class FuelPoint {
  final int x;
  final int y;

  FuelPoint(this.x, this.y);

  bool operator ==(dynamic other) =>
      other is FuelPoint && x == other.x && y == other.y;

  @override
  int get hashCode {
    return x * 1000000 + y;
  }

  distanceTo(FuelPoint other) {
    var dx = x - other.x;
    var dy = x - other.y;
    return dx.abs() + dy.abs();
  }

  String toString() => 'FuelPoint($x, $y)';
}

class FuelVector {
  final FuelPoint origin;
  final String direction;
  final int magnitude;
  final int wire;
  FuelPoint endPoint;

  FuelVector(this.origin, this.direction, this.magnitude, this.wire) {
    var scalar = _getScalar();
    endPoint = FuelPoint(origin.x + 1 * scalar[0], origin.y + 1 * scalar[1]);
  }

  bool operator ==(dynamic other) =>
      other is FuelVector && origin == other.origin && magnitude == other.magnitude && wire == other.wire;

  static FuelVector fromString(String vectorString, FuelPoint origin, int wire) {
    return FuelVector(
        origin, vectorString[0], int.parse(vectorString.substring(1)), wire);
  }

  FuelPoint intersects(FuelVector other) {
    if (wire == other.wire) return null;

    var p1 = origin;
    var p2 = endPoint;
    var p3 = other.origin;
    var p4 = other.endPoint;

    if (p1 == p4 || p2 == p3) return null;

    var det = ((p4.x - p3.x)*(p1.y - p2.y) - (p1.x - p2.x)*(p4.y - p3.y));

    var t = ((p3.y - p4.y)*(p1.x - p3.x) + (p4.x - p3.x)*(p1.y - p3.y))/det;
    if (t.isNaN || 0 > t || t > 1) return null;

    var u = ((p1.y - p2.y)*(p1.x - p3.x) + (p2.x - p1.x)*(p1.y - p3.y))/det;
    if (u.isNaN || 0 > u || u > 1) return null;
    // print('t: $t');
    // print('u: $u');

    if (0 <= t && t <= 1 && 0 <= u && u <= 1) {
      var ix = (p1.x + (t * (p2.x - p1.x))).toInt();
      var iy = (p1.y + (t * (p2.y - p1.y))).toInt();
      if (ix == 0 && iy == 0) return null;
      return FuelPoint(ix, iy);
    }

    return null;
  }

  List<FuelPoint> intersections(Set<FuelVector> vectors) {
    return vectors.map<FuelPoint>((otherVector) => intersects(otherVector)).toList();
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
          FuelPoint(origin.x + i * magX, origin.y + i * magY));
    }

    return points;
  }

  _getScalar() {
    switch (direction) {
      case 'U':
        return [0, magnitude];
      case 'D':
        return [0, -1 * magnitude];
      case 'L':
        return [-1 * magnitude, 0];
      case 'R':
        return [magnitude, 0];
      default:
        return [0, 0];
    }
  }
}
