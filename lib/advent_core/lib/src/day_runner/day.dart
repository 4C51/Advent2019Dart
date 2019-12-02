import 'package:colorize/colorize.dart';

import '../advent_files/advent_directory.dart';
import 'runner.dart';
import '../advent_files/advent_day.dart';
import 'solver.dart';

class DayRunner implements Runner {
  AdventDirectory _advent = new AdventDirectory();
  AdventDay _day;
  List<String> _input;
  Future _onReady;
  Solver _solver;

  DayRunner(Solver this._solver, {AdventDay day}) {
    if (day == null) {
      _day = _advent.getDay(_solver.day);
    } else {
      _day = day;
    }

    loadInput();
  }

  loadInput() async {
    _onReady = _day.getInput().then((input) => _input = input);
  }

  Future solve() async {
    print(Colorize('Solving Day ${_day.day}...')..lightGreen());
    await _onReady;
    await _solver(_day, _input);
  }

  static Future run(Solver solver) async {
    await new DayRunner(solver).solve();
  }
}