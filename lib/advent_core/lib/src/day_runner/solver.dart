import 'package:AdventCore/advent_files.dart';

abstract class Solver {
  int get day;

  Future call(AdventDay day, List<String> input) async => Future;
}