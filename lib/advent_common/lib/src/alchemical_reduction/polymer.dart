import 'unit.dart';

class Polymer {
  List<Unit> units;

  Polymer(List<Unit> this.units);

  reduce() {
    units = units.fold<List<Unit>>(new List(), (reduction, unit) {
      reduction.length > 0 && reduction.last.reactive(unit) ? reduction.removeLast() : reduction.add(unit);
      return reduction;
    });
  }

  reduceAll() {
    var reducedLength;
    do {
      reducedLength = units.length;
      reduce();
    } while (reducedLength < units.length);
  }

  Polymer extractType(String type) {
    return new Polymer(units..removeWhere((unit) => unit.type == type));
  }

  Polymer extractReduce() {
    return Unit.types
      .map((type) => new Polymer(List.from(units)).extractType(type)..reduceAll())
      .fold<Polymer>(null, (currentLowest, polymer) => (currentLowest != null && currentLowest.length < polymer.length) ? currentLowest : polymer);
  }

  int get length {
    return units.length;
  }

  static Polymer fromString(String units) {
    var splitString = units.split('');
    return new Polymer(splitString.map((units) => new Unit(units)).toList());
  }

  @override
  String toString() {
    return units.join();
  }
}