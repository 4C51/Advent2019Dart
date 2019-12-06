class Intcode {
  String _program;
  List<int> _memory;
  int _pointer;
  int _input;
  int _output;

  Intcode loadProgram(String programInput) {
    _program = programInput;
    _memory = programInput.split(',').map((i) => int.parse(i)).toList();
    return this;
  }

  Intcode execute([int input]) {
    if (_memory == null) throw 'Load program first.';
    var haltAndCatchFire = false;
    _pointer = 0;
    _input = input;

    while (!haltAndCatchFire) {
      haltAndCatchFire = _opcodeExecute(_memory[_pointer]);
    }

    return this;
  }

  Intcode writeMem(int address, int value) {
    _memory[address] = value;
    return this;
  }

  int readMem(int address) => _memory[address];

  get output => _output != null ? _output : _memory[0];

  readMemAll() => _memory.join(',');

  reset() => loadProgram(_program);

  _opcodeExecute(int insCode) {
    var opcodeMap = {
      1: _opcodeAdd,
      2: _opcodeMultiply,
      3: _opcodeInput,
      4: _opcodeOutput,
      5: _opcodeJumpIfTrue,
      6: _opcodeJumpIfFalse,
      7: _opcodeLessThan,
      8: _opcodeEquals,
      99: (_) => true
    };

    var ins = Instruction(insCode, _pointer, _memory);

    return opcodeMap[ins.opcode]?.call(ins) ??
        (throw 'Invalid opcode: ${ins.opcode}');
  }

  _opcodeAdd(Instruction ins) {
    ins(3, true);
    _memory[ins.output] = ins[0] + ins[1];
    _pointer += 4;
    return false;
  }

  _opcodeMultiply(Instruction ins) {
    ins(3, true);
    _memory[ins.output] = ins[0] * ins[1];
    _pointer += 4;
    return false;
  }

  _opcodeInput(Instruction ins) {
    ins(1, true);
    _memory[ins.output] = _input;
    _pointer += 2;
    return false;
  }

  _opcodeOutput(Instruction ins) {
    ins(1);
    _output = ins[0].value;
    _pointer += 2;
    return false;
  }

  _opcodeJumpIfTrue(Instruction ins) {
    ins(2);
    if (ins[0] != 0) {
      _pointer = ins[1].value;
    } else {
      _pointer += 3;
    }
    return false;
  }

  _opcodeJumpIfFalse(Instruction ins) {
    ins(2);
    if (ins[0] == 0) {
      _pointer = ins[1].value;
    } else {
      _pointer += 3;
    }
    return false;
  }

  _opcodeLessThan(Instruction ins) {
    ins(3, true);
    _memory[ins.output] = ins[0] < ins[1] ? 1 : 0;
    _pointer += 4;
    return false;
  }

  _opcodeEquals(Instruction ins) {
    ins(3, true);
    _memory[ins.output] = ins[0] == ins[1] ? 1 : 0;
    _pointer += 4;
    return false;
  }
}

class Instruction {
  final int insCode;
  final List<int> _memory;
  final int address;
  List<Parameter> _params = List<Parameter>();
  int opcode;

  Instruction(this.insCode, this.address, this._memory) {
    opcode = insCode % 100;
  }

  call(int inputCount, [bool hasOutput = false]) {
    var params = _memory.getRange(address + 1, address + 1 + inputCount).toList();
    _params.length = params.length;

    for (var i = 0, modeBits = insCode ~/ 100; i < params.length; i++, modeBits ~/= 10) {
      _params[i] = Parameter(params[i], Mode.values[modeBits % 10], hasOutput && i + 1 == params.length, _memory);
    }
  }

  List<Parameter> get params => _params;

  get output => _params.last.value;

  operator [](int index) {
    return _params[index];
  } 
}

class Parameter {
  final Mode mode;
  final int _value;
  final bool isOutput;
  final List<int> _memory;

  Parameter(this._value, this.mode, this.isOutput, this._memory);

  int get value {
    if (isOutput) return _value;
    if (mode == Mode.Position) return _memory[_value];
    if (mode == Mode.Immediate) return _value;
    throw 'Unknown mode.';
  }

  operator ==(dynamic other) {
    if (other is Parameter) {
      return value == other.value;
    }
    
    return value == other;
  }

  operator +(Parameter other) {
    return value + other.value;
  }

  operator *(Parameter other) {
    return value * other.value;
  }

  operator <(Parameter other) {
    return value < other.value;
  }

  operator >(Parameter other) {
    return value > other.value;
  }
}

enum Mode { Position, Immediate }
