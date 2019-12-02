import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import 'package:AdventCore/advent_files.dart';
import 'dart:io';

import 'advent_calendar.dart';

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
      for (var i = 1; i <= 25; i++) {
        await AdventCalendar.runDay(i);
      }
    } else {
      await AdventCalendar.runDay(int.parse(dayInput));
    }
  } on AdventDirectoryMissingException {} on AdventDayInputMissingException {}
}
