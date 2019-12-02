import 'package:AdventCore/day_runner.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import 'package:AdventCore/advent_files.dart';
import 'dart:io';

import 'days/day1.dart';
import 'days/day2.dart';

var days = [
  () => DayRunner.run(new FirstDay()),
  () => DayRunner.run(new SecondDay())
];

ArgResults argResults;

void main(List<String> arguments) async {
  var dayInput;
  AdventDirectory.setAdventDirectory(p.absolute(p.current, 'days'));
  final argParser = new ArgParser()..addOption('day', abbr: 'd');
  argResults = argParser.parse(arguments);
  dayInput = argResults['day'];

  if (argResults['day'] == null) {
    print('Enter a day to run (or all):');
    dayInput = stdin.readLineSync().trim();
  }

  try {
    if (dayInput == 'all') {
      for (var dayRunner in days) {
        await dayRunner();
      }
    } else {
      await days[int.parse(dayInput) - 1]();
    }
  } on AdventDirectoryMissingException {} on AdventDayInputMissingException {}
}
