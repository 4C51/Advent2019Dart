import 'dart:io';
import 'advent_day.dart';
import 'package:path/path.dart';
import 'package:colorize/colorize.dart';

class AdventDirectoryMissingException implements Exception {}

class AdventDirectory {
  Directory _adventDir;
  List<Directory> _adventDays = new List<Directory>();
  static Directory _defaultAdventDir;

  AdventDirectory([String directory]) {
    _adventDir = directory == null ? _defaultAdventDir : new Directory(directory);

    for (var fe in _adventDir.listSync()) {
      if (fe is Directory) {
        _adventDays.add(fe);
      }
    }
  }

  static setAdventDirectory(String directory) {
    _defaultAdventDir = new Directory(directory);
  }

  AdventDay getDay(int day) {
    var adventDay = _adventDays.firstWhere((dir) => basename(dir.path) == day.toString(), orElse: () => null);

    if (adventDay == null) {
      print(new Colorize('Error: Missing directory for day $day')..lightRed());
      throw new AdventDirectoryMissingException();
    }

    return new AdventDay(adventDay, day);
  }
}