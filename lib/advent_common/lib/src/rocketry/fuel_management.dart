class FuelCircuit {
  final vectors = Set<FuelVector>();
  final origin = FuelPoint(0, 0);
  final signals = List<Signal>();

  FuelCircuit();

  addPath(String path, int wire) {
    var vectorStrings = path.split(',');
    var previousOrigin = origin;
    var currentSignal = Signal(wire);
    signals.add(currentSignal);

    for (var i = 0; i < vectorStrings.length; i++) {
      var vector = FuelVector.fromString(vectorStrings[i], previousOrigin, wire, currentSignal);
      vectors.add(vector);
      previousOrigin = vector.endPoint;
      currentSignal.addVector(vector);
    }
  }

  List<Intersection> getIntersections() {
    var ints = List<Intersection>();
    var intersections = vectors.fold<List<Intersection>>(ints, (ints, vector) {
      ints.addAll(vector.intersections(vectors));
      return ints;
    }).toSet().toList();
    intersections.removeWhere((intersection) => intersection == null);
    return intersections;
  }

  Intersection getClosestIntersection() {
    var intersections = getIntersections();
    return intersections.reduce(
        (interA, interB) =>
            origin.distanceTo(interA) < origin.distanceTo(interB)
                ? interA
                : interB);
  }

  Intersection getLowestDelayIntersection() {
    var intersections = getIntersections();
    return intersections.reduce((interA, interB) => interA.signalDelay < interB.signalDelay ? interA : interB);
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

  int distanceTo(FuelPoint other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return dx.abs() + dy.abs();
  }

  String toString() => 'FuelPoint($x, $y)';
}

class FuelVector {
  final FuelPoint origin;
  final String direction;
  final int magnitude;
  final int wire;
  final Signal signal;
  FuelPoint endPoint;

  FuelVector(this.origin, this.direction, this.magnitude, this.wire, this.signal) {
    var scalar = _getScalar();
    endPoint = FuelPoint(origin.x + 1 * scalar[0], origin.y + 1 * scalar[1]);
  }

  bool operator ==(dynamic other) =>
      other is FuelVector && origin == other.origin && magnitude == other.magnitude && wire == other.wire;

  static FuelVector fromString(String vectorString, FuelPoint origin, int wire, Signal signal) {
    return FuelVector(
        origin, vectorString[0], int.parse(vectorString.substring(1)), wire, signal);
  }

  Intersection intersects(FuelVector other) {
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
      return Intersection(ix, iy, this, other);
    }

    return null;
  }

  List<Intersection> intersections(Set<FuelVector> vectors) {
    return vectors.map<Intersection>((otherVector) => intersects(otherVector)).toList();
  }

  int getDelayAt(FuelPoint point) {
    return signalDelay + origin.distanceTo(point);
  }

  int get signalDelay => signal.getVectorDelay(this);

  @override
  String toString() => 'FuelVector<$wire>($origin, $direction, $magnitude, $signalDelay)';

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

class Intersection extends FuelPoint {
  final FuelVector vectorA;
  final FuelVector vectorB;
  Intersection(int x, int y, this.vectorA, this.vectorB) : super(x, y);

  int get signalDelay {
    return vectorA.getDelayAt(this) + vectorB.getDelayAt(this);
  }

  @override
  String toString() => 'Intersection($x, $y, $signalDelay [${vectorA.getDelayAt(this)}, ${vectorB.getDelayAt(this)}])';

  @override
  int get hashCode {
    return x * 1000000 + y + signalDelay;
  }

  @override
  bool operator ==(dynamic other) =>
      other is Intersection && x == other.x && y == other.y && signalDelay == other.signalDelay;
}

class Signal {
  final int wire;

  Signal(this.wire);
  
  final List<FuelVector> vectors = [];

  int get delay => vectors.fold(0, (delay, vector) => delay + vector.magnitude);

  int getVectorDelay(FuelVector vector) => vectors.takeWhile((v) => v != vector).fold(0, (delay, v) => delay + v.magnitude);

  addVector(FuelVector vector) => vectors.add(vector);

  @override
  String toString() => 'Signal<$wire>(${vectors.map((vector) => vector.magnitude)}: $delay)';
}