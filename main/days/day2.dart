import 'package:AdventCommon/rocketry.dart';
import 'package:AdventCore/advent_files.dart';
import 'package:AdventCore/day_runner.dart';

class Day2 implements Solver {
  final day = 2;

  call(AdventDay day, List<String> input) async {
    var computer = Intcode()
      ..loadProgram(input[0])
      ..writeMem(1, 12)
      ..writeMem(2, 2)
      ..execute();

    await day.writePart1(computer.output.toString());

    var haltCode = 0;

    search:
    for (var noun = 0; noun <= 99; noun++) {
      for (var verb = 0; verb <= 99; verb++) {
        computer.reset()
          ..writeMem(1, noun)
          ..writeMem(2, verb)
          ..execute();

        if (computer.output == 19690720) {
          haltCode = 100 * noun + verb;
          break search;
        }
      }
    }

    await day.writePart2(haltCode.toString());
  }
}
