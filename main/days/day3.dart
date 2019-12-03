import 'package:AdventCommon/rocketry.dart';
import 'package:AdventCore/day_runner.dart';
import 'package:AdventCore/src/advent_files/advent_day.dart';

class Day3 implements Solver {
  final day = 3;

  call(AdventDay day, List<String> input) async {
    var circuit = FuelCircuit();
    circuit.addPath('R75,D30,R83,U83,L12,D49,R71,U7,L72', 1);
    circuit.addPath('U62,R66,U55,R34,D71,R55,D58,R83', 2);
    print(circuit.getIntersections());
    day.writePart1(circuit.origin.distanceTo(circuit.getClosestIntersection()).toString());
  }
}
