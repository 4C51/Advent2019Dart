class Intcode {
  String _program;
  List<int> _memory;
  int _pointer;

  Intcode loadProgram(String input) {
    _program = input;
    var programInputs = input.split(',').map((i) => int.parse(i)).toList();
    _memory = programInputs;
    return this;
  }

  Intcode execute() {
    if (_memory == null) throw 'Load program first.';
    var haltAndCatchFire = false;
    _pointer = 0;

    while (!haltAndCatchFire) {
      haltAndCatchFire =
          _opcodeExecute(_memory[_pointer]);
    }

    return this;
  }

  Intcode writeMem(int address, int value) {
    _memory[address] = value;
    return this;
  }

  int readMem(int address) => _memory[address];

  get output => _memory[0];

  readMemAll() => _memory.join(',');

  reset() => loadProgram(_program);

  _opcodeExecute(int opcode) {
    var opcodeMap = {
      1: _opcodeAdd,
      2: _opcodeMultiply,
      99: () => true
    };

    return opcodeMap[opcode]?.call() ?? (throw 'Invalid opcode: ${opcode}');
  }

  Instructions _getInstructions(int outputOffset, int inputCount) {
    var ins = Instructions();
    ins.outputAddress = _memory[_pointer + outputOffset];
    for (var i = 1; i <= inputCount; i++) {
      ins.inputs.add(_memory[_memory[_pointer + i]]);
    }
    return ins;
  }

  _opcodeAdd() {
    var ins = _getInstructions(3, 2);
    _memory[ins.outputAddress] = ins.inputs[0] + ins.inputs[1];
    _pointer += 4;
    return false;
  }

  _opcodeMultiply() {
    var ins = _getInstructions(3, 2);
    _memory[ins.outputAddress] = ins.inputs[0] * ins.inputs[1];
    _pointer += 4;
    return false;
  }
}

class Instructions {
  int outputAddress;
  List<int> inputs = [];
}