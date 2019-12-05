import 'package:AdventCommon/password_guessing.dart';
import 'package:AdventCore/day_runner.dart';
import 'package:AdventCore/src/advent_files/advent_day.dart';

class Day4 implements Solver {
  final day = 4;

  @override
  Future call(AdventDay day, List<String> input) async {
    var password = Password();
    password.setRange(input[0]);
    await day.writePart1(password.countCandidates().toString());
    password.strictDoubleRule = true;
    await day.writePart2(password.countCandidates().toString());
  }
}
