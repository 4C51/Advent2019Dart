import 'intcode_operations.dart';

class Intcode {
  String _program;
  final _memory = Memory();
  MemPointer _pointer;

  Intcode loadProgram(String programInput) {
    _program = programInput;
    _memory.load(programInput.split(',').map((i) => int.parse(i)).toList());
    return this;
  }

  Intcode execute([dynamic input]) {
    if (!_memory.programLoaded) throw 'Load program first.';
    var haltAndCatchFire = false;
    _pointer = MemPointer(_memory);
    _memory.input = IO.Input(input);

    while (!haltAndCatchFire) {
      haltAndCatchFire = Operation.create(_pointer).exec();
    }

    return this;
  }

  Intcode writeMem(int address, int value) {
    _memory(address, value);
    return this;
  }

  int readMem(int address) => _memory[address];

  IO get output =>
      !_memory.output.isEmpty ? _memory.output : IO.Output(_memory[0]);
  int get outputLast => _memory.output.last;

  readMemAll() => _memory.toString();

  reset() => loadProgram(_program);
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
    if (!isInput) throw 'Cannot read from Output';
    var val = _memory[_pointer];
    _pointer++;
    return val;
  }

  write(int value, [int address]) {
    if (isInput) throw 'Cannot write to Input';
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
