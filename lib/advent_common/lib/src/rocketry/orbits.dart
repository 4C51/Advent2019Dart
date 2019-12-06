class System {
  final Map<String, Celestial> celestials = Map<String, Celestial>();

  System();

  factory System.fromMap(List<String> map) {
    var system = System();

    map.forEach((orbit) {
      var idents = orbit.split(')');
      system.celestials[idents[0]] =
          system.celestials[idents[0]] ?? Celestial(idents[0]);
      system.celestials[idents[1]] =
          system.celestials[idents[1]] ?? Celestial(idents[1]);
      system.celestials[idents[1]].addParent(system.celestials[idents[0]]);
    });

    return system;
  }

  int get orbits => celestials.entries.fold(0, (v, c) => v += c.value.orbits);

  int calculateTransfers(String origin, String destination) {
    var nearest = getNearest(origin, destination);
    return celestials[origin].transfersToTarget(nearest) +
        celestials[destination].transfersToTarget(nearest) -
        2;
  }

  Celestial getNearest(String a, String b) {
    var parentsA = celestials[a].parents();
    var parentsB = celestials[b].parents();
    var shared = parentsA.intersection(parentsB).toList()..sort();
    return shared.last;
  }
}

class Celestial implements Comparable<Celestial> {
  Celestial parent;
  final Set<Celestial> orbitals = Set<Celestial>();
  final String identifier;

  Celestial(this.identifier);

  addParent(Celestial parent) {
    this.parent = parent;
    this.parent.orbitals.add(this);
  }

  int get orbits => parent != null ? parent.orbits + 1 : 0;

  Set<Celestial> parents([Set<Celestial> parents]) {
    var currentSet = (parents ?? Set<Celestial>())..add(this);
    return parent?.parents(currentSet) ?? currentSet;
  }

  int transfersToTarget(Celestial target) {
    return target == this ? 0 : parent.transfersToTarget(target) + 1;
  }

  operator ==(dynamic other) {
    return other is Celestial && identifier == other.identifier;
  }

  operator <(Celestial other) => orbits < other.orbits;
  operator >(Celestial other) => orbits > other.orbits;

  @override
  int get hashCode => identifier.hashCode;

  @override
  int compareTo(Celestial other) {
    if (this < other) return -1;
    if (this > other) return 1;
    return 0;
  }
}
