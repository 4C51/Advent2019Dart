import 'package:AdventCore/advent_files.dart';
import 'package:AdventCore/day_runner.dart';
import 'package:AdventCommon/rocketry.dart';

class Day1 implements Solver {
  final day = 1;

  call(AdventDay day, List<String> input) async {
    List<RocketEquation> calcs = [];
    for (var i = 0; i < input.length; i++) {
      calcs.add(RocketEquation(int.parse(input[i])));
    }

    var totalInitialFuel = 0;
    for (var i = 0; i < calcs.length; i++) {
      totalInitialFuel += calcs[i].initialFuel;
    }

    await day.writePart1(totalInitialFuel.toString());

    var totalFuel = 0;
    for (var i = 0; i < calcs.length; i++) {
      totalFuel += calcs[i].totalFuel;
    }

    await day.writePart2(totalFuel.toString());
  }
}
