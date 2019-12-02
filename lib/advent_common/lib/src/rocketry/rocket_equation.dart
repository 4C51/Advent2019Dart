class RocketEquation {
  final int mass;
  int initialFuel;
  int totalFuel;

  RocketEquation(this.mass) {
    initialFuel = calculateFuel(mass);
    totalFuel = initialFuel;

    var remainingFuel = calculateFuel(initialFuel);
    while (remainingFuel > 0) {
      totalFuel += remainingFuel;
      remainingFuel = calculateFuel(remainingFuel);
    }
  }
}

int calculateFuel(int mass) {
  return (mass / 3).floor() - 2;
}
