import 'package:AdventCore/advent_files.dart';

abstract class Solver {
  String day;

  Future call(AdventDay day, List<String> input) async => Future;
}