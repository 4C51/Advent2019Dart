import 'package:AdventCommon/rocketry.dart';
import 'package:AdventCore/day_runner.dart';
import 'package:AdventCore/src/advent_files/advent_day.dart';

class Day5 implements Solver {
  final day = 5;

  @override
  Future call(AdventDay day, List<String> input) async {
    var computer = IntcodeComputer()..loadProgram('TEST', input[0]);

    day.startPart1();
    computer.run('TEST', input: [1]).then((result) {
      day.writePart1(result.last.toString());
    });

    day.startPart2();
    computer.run('TEST', input: [5]).then((result) {
      day.writePart2(result.toString());
    });
  }
}
