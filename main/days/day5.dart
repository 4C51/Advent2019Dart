import 'package:AdventCommon/rocketry.dart';
import 'package:AdventCore/day_runner.dart';
import 'package:AdventCore/src/advent_files/advent_day.dart';

class Day5 implements Solver {
  final day = 5;

  @override
  Future call(AdventDay day, List<String> input) async {
    var computer = Intcode()
      ..loadProgram(input[0])
      ..execute(1);

    await day.writePart1(computer.output.toString());

    await day.writePart2('');
  }
}
