import 'package:AdventCommon/rocketry.dart';
import 'package:AdventCore/day_runner.dart';
import 'package:AdventCore/src/advent_files/advent_day.dart';

class Day6 implements Solver {
  final day = 6;

  @override
  Future call(AdventDay day, List<String> input) async {
    var system = System.fromMap(input);
    await day.writePart1(system.orbits.toString());

    await day.writePart2(system.calculateTransfers('YOU', 'SAN').toString());
  }
}
