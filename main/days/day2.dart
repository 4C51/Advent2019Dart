import 'package:AdventCommon/rocketry.dart';
import 'package:AdventCore/advent_files.dart';
import 'package:AdventCore/day_runner.dart';

class Day2 implements Solver {
  final day = 2;

  call(AdventDay day, List<String> input) async {
    var computer = IntcodeComputer()..loadProgram('diag', input[0]);

    day.startPart1();
    await computer
        .run('diag', instructionOverrides: {1: 12, 2: 2}).then((result) {
      day.writePart1(result.toString());
    });

    day.startPart2();
    var haltCode;
    search:
    for (var noun = 0; noun <= 99; noun++) {
      for (var verb = 0; verb <= 99; verb++) {
        await computer.run('diag',
            instructionOverrides: {1: noun, 2: verb}).then((result) {
          if (result == 19690720) {
            haltCode = 100 * noun + verb;
            day.writePart2(haltCode.toString());
            computer.killAll();
          }
        });
      }
    }
  }
}
