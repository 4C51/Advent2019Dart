import 'package:AdventCommon/rocketry.dart';
import 'package:AdventCore/day_runner.dart';
import 'package:AdventCore/src/advent_files/advent_day.dart';

class Day7 implements Solver {
  final day = 7;

  @override
  Future call(AdventDay day, List<String> input) async {
    var ampCircuit = AmpCircuit(input[0]);
    await day.writePart1(ampCircuit.findMax(0).toString());

    await day.writePart2('');
  }
}
