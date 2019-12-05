class Intcode {
  String _program;
  List<int> _memory;
  int _pointer;
  int _input;
  int _output;

  Intcode loadProgram(String programInput) {
    _program = programInput;
    var programInputs =
        programInput.split(',').map((i) => int.parse(i)).toList();
    _memory = programInputs;
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

  List<int> _getParams(int inputCount) {
    return _memory.getRange(_pointer + 1, _pointer + 1 + inputCount).toList();
  }

  _opcodeAdd(Instruction ins) {
    ins.setParams(_getParams(3), 2);
    _memory[ins.outputAddress] = ins.params[0] + ins.params[1];
    _pointer += 4;
    return false;
  }

  _opcodeMultiply(Instruction ins) {
    ins.setParams(_getParams(3), 2);
    _memory[ins.outputAddress] = ins.params[0] * ins.params[1];
    _pointer += 4;
    return false;
  }

  _opcodeInput(Instruction ins) {
    ins.setParams(_getParams(1), 0);
    _memory[ins.outputAddress] = _input;
    _pointer += 2;
    return false;
  }

  _opcodeOutput(Instruction ins) {
    ins.setParams(_getParams(1));
    _output = ins.params[0];
    _pointer += 2;
    return false;
  }

  _opcodeJumpIfTrue(Instruction ins) {
    ins.setParams(_getParams(2));
    if (ins.params[0] != 0) {
      _pointer = ins.params[1];
    } else {
      _pointer += 3;
    }
    return false;
  }

  _opcodeJumpIfFalse(Instruction ins) {
    ins.setParams(_getParams(2));
    if (ins.params[0] == 0) {
      _pointer = ins.params[1];
    } else {
      _pointer += 3;
    }
    return false;
  }

  _opcodeLessThan(Instruction ins) {
    ins.setParams(_getParams(3), 2);
    _memory[ins.outputAddress] = ins.params[0] < ins.params[1] ? 1 : 0;
    _pointer += 4;
    return false;
  }

  _opcodeEquals(Instruction ins) {
    ins.setParams(_getParams(3), 2);
    _memory[ins.outputAddress] = ins.params[0] == ins.params[1] ? 1 : 0;
    _pointer += 4;
    return false;
  }
}

class Instruction {
  final int insCode;
  final List<int> _memory;
  final int address;
  List<int> _params;
  List<Mode> _modes;
  int _outputAddress;
  int opcode;

  Instruction(this.insCode, this.address, this._memory) {
    opcode = insCode % 100;
  }

  setParams(List<int> params, [int outputParam]) {
    _params = params;
    _modes = (insCode ~/ 100)
        .toString()
        .padLeft(3, '0')
        .split('')
        .reversed
        .toList()
        .map<Mode>((m) => Mode.values[int.parse(m)])
        .toList();

    for (var i = 0; i < params.length; i++) {
      _params[i] = _getParamValue(_modes[i], params[i], outputParam == i);
    }
  }

  get params => _params;

  get outputAddress => _outputAddress;

  int _getParamValue(Mode mode, int value, [bool isOutput = false]) {
    if (isOutput) {
      _outputAddress = value;
      return value;
    }

    if (mode == Mode.Position) return _memory[value];
    if (mode == Mode.Immediate) return value;
    throw 'Unknown mode';
  }
}

enum Mode { Position, Immediate }
