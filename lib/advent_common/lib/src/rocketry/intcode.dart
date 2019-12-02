class Intcode {
  String _program;
  List<int> _memory;
  int _pointer;

  loadProgram(String input) {
    _program = input;
    var programInputs = input.split(',').map((i) => int.parse(i)).toList();
    _memory = programInputs;
  }

  execute() {
    if (_memory == null) throw 'Load program first.';
    var haltAndCatchFire = false;
    _pointer = 0;

    while (!haltAndCatchFire) {
      haltAndCatchFire =
          _opcodeExecute(_memory.sublist(_pointer, _pointer + 4));
    }
  }

  writeMem(int address, int value) {
    _memory[address] = value;
  }

  int readMem(int address) => _memory[address];

  get output => _memory[0];

  readMemAll() => _memory.join(',');

  reset() => loadProgram(_program);

  _opcodeExecute(List<int> instructions) {
    switch (instructions[0]) {
      case 1:
        _opcodeAdd(instructions);
        _pointer += 4;
        return false;
      case 2:
        _opcodeMultiply(instructions);
        _pointer += 4;
        return false;
      case 99:
        return true;
      default:
        throw 'Invalid opcode: ${instructions[0]}';
    }
  }

  _opcodeAdd(List<int> instructions) {
    _memory[instructions[3]] =
        _memory[instructions[1]] + _memory[instructions[2]];
  }

  _opcodeMultiply(List<int> instructions) {
    _memory[instructions[3]] =
        _memory[instructions[1]] * _memory[instructions[2]];
  }
}
