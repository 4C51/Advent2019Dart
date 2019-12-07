import 'package:AdventCommon/rocketry.dart';
import 'package:AdventCore/day_runner.dart';
import 'package:AdventCore/src/advent_files/advent_day.dart';

class Day7 implements Solver {
  final day = 7;

  @override
  Future call(AdventDay day, List<String> input) async {
    var ampCircuit = AmpCircuit(input[0]);
    var max = await ampCircuit.findMax(0);
    await day.writePart1(max.toString());

    var ampCircuit2 = AmpCircuit(
        '3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5',
        loop: true);
    await day.writePart2(ampCircuit2.findMaxLoop(0).toString());
  }
}
