import 'package:AdventCommon/rocketry.dart';
import 'package:AdventCore/advent_files.dart';
import 'package:AdventCore/day_runner.dart';

class SecondDay implements Solver {
  String day = '2';

  call(AdventDay day, List<String> input) async {
    var computer = Intcode();
    computer.loadProgram(input[0]);
    computer.writeMem(1, 12);
    computer.writeMem(2, 2);
    computer.execute();

    print(computer.output.toString());

    await day.writePart1(computer.output.toString());

    var haltCode = 0;

    search:
    for (var noun = 0; noun <= 99; noun++) {
      for (var verb = 0; verb <= 99; verb++) {
        computer.reset();
        computer.writeMem(1, noun);
        computer.writeMem(2, verb);
        computer.execute();

        if (computer.output == 19690720) {
          haltCode = 100 * noun + verb;
          break search;
        }
      }
    }

    print(haltCode);
    await day.writePart2(haltCode.toString());
  }
}
