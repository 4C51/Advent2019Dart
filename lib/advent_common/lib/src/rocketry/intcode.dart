import 'dart:async';
import 'dart:collection';

import 'intcode_operations.dart';

class IntcodeComputer {
  String _program;
  final _memory = Memory();
  MemPointer _pointer;
  Timer _timer;
  HashSet<Thread> _threads = HashSet();
  HashSet<Program> _programs = HashSet();

  IntcodeComputer loadProgram(String name, String programInput) {
    _programs.add(Program(name, programInput));
    return this;
  }

  Future<IO> run(String programName,
      {List<int> input, Map<int, int> instructionOverrides}) {
    var thread = Thread(_getProgram(programName), input ?? [],
        instructionOverrides: instructionOverrides);
    _threads.add(thread);
    return thread.onComplete.whenComplete(() {
      _threads.remove(thread);
    });
  }

  killAll() {
    _threads.forEach((t) => t.kill());
    _threads.clear();
  }

  _getProgram(String name) => _programs.singleWhere((p) => p._name == name);

  reset() => () => {};
}

class Thread {
  Memory _memory = Memory();
  MemPointer _pointer;
  Program _program;
  Completer<IO> _completer;
  Timer _timer;
  bool killed = false;

  Thread(this._program, List<int> input, {Map<int, int> instructionOverrides}) {
    _memory.load(_program.instructions);
    _pointer = MemPointer(_memory);
    _memory.input = IO.Input();
    input.forEach((i) => _memory.input.write(i));

    if (instructionOverrides != null) {
      for (var override in instructionOverrides.entries) {
        _memory(override.key, override.value);
      }
    }

    _timer = Timer.periodic(Duration(microseconds: 1), _opTick);
    _completer = Completer();
  }

  _opTick(Timer timer) {
    try {
      var halt = Operation.create(_pointer).exec();
      if (halt) {
        _timer.cancel();
        _completer.complete(output);
      }
    } catch (e) {
      _completer.completeError(e);
    }
  }

  IO get output =>
      !_memory.output.isEmpty ? _memory.output : IO.Output(_memory[0]);
  int get outputLast => _memory.output.last;

  Future<IO> get onComplete => _completer?.future ?? Future.value();

  kill() {
    if (_timer.isActive) _timer.cancel();
    if (!_completer.isCompleted) _completer.complete(null);
    killed = true;
  }
}

class Program {
  String _name;
  String _code;

  Program(this._name, this._code);

  List<int> get instructions =>
      _code.split(',').map((i) => int.parse(i)).toList();
}

class Memory {
  List<int> _memory = List<int>();
  bool programLoaded = false;
  IO input;
  final IO output = IO.Output();

  load(List<int> data) {
    _memory = data;
    input?.clear();
    output.clear();
    programLoaded = true;
  }

  List<int> getRange(int start, int end) =>
      _memory.getRange(start, end).toList();

  operator [](int address) => _memory[address];
  call(int address, int value) => _memory[address] = value;

  @override
  String toString() => _memory.join(',');
}

class Instruction {
  final MemPointer _pointer;
  List<Parameter> _params = List<Parameter>();
  int opcode;

  Instruction(this._pointer, int paramCount, [bool hasOutput = false]) {
    var params = _pointer.getParams(paramCount);
    _params.length = params.length;

    for (var i = 0, modeBits = _pointer.current ~/ 100;
        i < params.length;
        i++, modeBits ~/= 10) {
      _params[i] = Parameter(params[i], Mode.values[modeBits % 10],
          hasOutput && i + 1 == params.length, _pointer);
    }
  }

  List<Parameter> get params => _params;

  int get output => _params.last.value;

  Parameter operator [](int index) => _params[index];
}

class MemPointer {
  final Memory _memory;
  int _pointer;

  MemPointer(this._memory, [this._pointer = 0]);

  void advance([int val = 1]) => _pointer += val;
  void call(int val) => _pointer = val;

  int get current => _memory[_pointer];
  int get opcode => current % 100;

  List<int> getParams(int count) =>
      _memory.getRange(_pointer + 1, _pointer + 1 + count);

  void write(int address, int value) => _memory(address, value);

  int get input => _memory.input.read();
  set output(int val) => _memory.output.write(val);

  reset() => _pointer = 0;

  operator [](int address) => _memory[address];
}

class Parameter {
  final Mode mode;
  final int _value;
  final bool isOutput;
  final MemPointer _pointer;

  Parameter(this._value, this.mode, this.isOutput, this._pointer);

  int get value {
    if (isOutput) return _value;
    if (mode == Mode.Position) return _pointer[_value];
    if (mode == Mode.Immediate) return _value;
    throw 'Unknown mode.';
  }

  operator ==(dynamic other) =>
      other is Parameter ? value == other.value : value == other;
  operator +(Parameter other) => value + other.value;
  operator *(Parameter other) => value * other.value;
  operator <(Parameter other) => value < other.value;
  operator >(Parameter other) => value > other.value;
}

class IO {
  final List<int> _memory = List<int>();
  final bool isInput;
  int _pointer = 0;

  IO(this.isInput, [dynamic data]) {
    if (data != null) _memory.addAll(data is int ? [data] : data);
  }

  int operator [](int address) => _memory[address];
  bool operator ==(dynamic other) =>
      other is IO ? this == other : last == other;

  bool get isEmpty => _memory.isEmpty;

  int get last => _memory.last;

  int read([int address]) {
    if (_pointer >= _memory.length) throw 'Cannot read input!';
    var val = _memory[_pointer];
    _pointer++;
    return val;
  }

  write(int value, [int address]) {
    _memory.add(value);
  }

  flush() => _memory;
  clear() => _memory.clear();

  factory IO.Input([dynamic data]) => IO(true, data);
  factory IO.Output([dynamic data]) => IO(false, data);

  @override
  String toString() => _memory.join(',');
}

enum Mode { Position, Immediate }
