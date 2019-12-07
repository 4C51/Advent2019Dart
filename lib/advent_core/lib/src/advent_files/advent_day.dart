import 'dart:io';

import 'package:colorize/colorize.dart';

class AdventDayInputMissingException implements Exception {}

class AdventDay {
  Directory dayDir;
  int day;
  File _input;
  File _outputPart1;
  File _outputPart2;
  Stopwatch _stopwatch = Stopwatch();
  Stopwatch _part1Watch = Stopwatch();
  Stopwatch _part2Watch = Stopwatch();

  /**
   * Creates an [AdventDay] object to load and write data
   * 
   * The directory [dayDir] should be the directory containing input.txt
   * */
  AdventDay(Directory this.dayDir, int this.day) {
    _input = new File(dayDir.path + '/input.txt');
    _outputPart1 = new File(dayDir.path + '/output_part1.txt');
    _outputPart2 = new File(dayDir.path + '/output_part2.txt');
  }

  /// Load the input data from <day>/input.txt
  Future<List<String>> getInput() async {
    var inputExists = await _input.exists();

    if (!inputExists) {
      print(new Colorize('Cannot find input for day $day')..lightRed());
      throw new AdventDayInputMissingException();
    }

    return await _input.readAsLines();
  }

  Future _writeOutput(File file, String data) async {
    return file.create().then((file) => file.writeAsString(data));
  }

  /// Write the first part of the advent day output to <day>/output_part1.txt
  Future writePart1(String data) async {
    print('Part 1 [$part1Time]: $data');
    _stopwatch.reset();
    return _writeOutput(_outputPart1, data);
  }

  /// Write the second part of the advent day output to <day>/output_part2.txt
  Future writePart2(String data) async {
    print('Part 2 [$part2Time]: $data\n');
    return _writeOutput(_outputPart2, data);
  }

  start() => _stopwatch.start();
  startPart1() => _part1Watch.start();
  startPart2() => _part2Watch.start();

  String get executionTime => '${_stopwatch.elapsed.inMilliseconds}ms';
  String get part1Time => _part1Watch.isRunning
      ? '${_part1Watch.elapsed.inMilliseconds}ms'
      : executionTime;
  String get part2Time => _part2Watch.isRunning
      ? '${_part2Watch.elapsed.inMilliseconds}ms'
      : executionTime;
}
