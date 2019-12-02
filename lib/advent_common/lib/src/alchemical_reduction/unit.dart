enum Polarity {
  Upper,
  Lower
}

final upper = new RegExp(r'[A-Z]');

class Unit {
  Polarity polarity;
  String type;

  Unit(String unitString) {
    type = unitString.toLowerCase();
    polarity = upper.hasMatch(unitString) ? Polarity.Upper : Polarity.Lower;
  }

  samePolarity(Unit other) {
    return polarity == other.polarity;
  }

  sameType(Unit other) {
    return type == other.type;
  }

  reactive(Unit other) {
    return sameType(other) && !samePolarity(other);
  }

  @override
  String toString() {
    return polarity == Polarity.Upper ? type.toUpperCase() : type;
  }

  static final types = 'abcdefghijklmnopqrstuvwxyz'.split('').toSet();
}