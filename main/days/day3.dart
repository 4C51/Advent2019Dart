import 'package:AdventCommon/rocketry.dart';
import 'package:AdventCore/day_runner.dart';
import 'package:AdventCore/src/advent_files/advent_day.dart';

class Day3 implements Solver {
  final day = 3;

  call(AdventDay day, List<String> input) async {
    var circuit = FuelCircuit();
    circuit.addPath(input[0], 1);
    circuit.addPath(input[1], 2);
    day.writePart1(circuit.origin.distanceTo(circuit.getClosestIntersection()).toString());
    day.writePart2(circuit.getLowestDelayIntersection().signalDelay.toString());
  }
}
