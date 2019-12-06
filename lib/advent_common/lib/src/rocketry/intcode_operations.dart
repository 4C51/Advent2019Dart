import 'intcode.dart';

abstract class Operation {
  final MemPointer _pointer;
  final int opcode = 99;
  final int params = 3;
  final bool hasOutput = true;
  Instruction _ins;

  Operation(this._pointer) {
    _ins = Instruction(_pointer, params, hasOutput);
  }

  bool exec() {
    advancePointer();
    return false;
  }

  void advancePointer() => _pointer.advance(params + 1);

  factory Operation.create(MemPointer pointer) {
    switch (pointer.opcode) {
      case 1:
        return AddOp(pointer);
      case 2:
        return MultiplyOp(pointer);
      case 3:
        return InputOp(pointer);
      case 4:
        return OutputOp(pointer);
      case 5:
        return JumpIfTrueOp(pointer);
      case 6:
        return JumpIfFalseOp(pointer);
      case 7:
        return LessThanOp(pointer);
      case 8:
        return EqualsOp(pointer);
      case 99:
        return HaltOp(pointer);
      default:
        throw 'No handler for opcode: ${pointer.opcode}';
    }
  }
}

class AddOp extends Operation {
  final opcode = 1;
  AddOp(pointer) : super(pointer);

  @override
  bool exec() {
    _pointer.write(_ins.output, _ins[0] + _ins[1]);
    return super.exec();
  }
}

class MultiplyOp extends Operation {
  final opcode = 2;
  MultiplyOp(MemPointer pointer) : super(pointer);

  @override
  bool exec() {
    _pointer.write(_ins.output, _ins[0] * _ins[1]);
    return super.exec();
  }
}

class InputOp extends Operation {
  final opcode = 3;
  final params = 1;

  InputOp(MemPointer pointer) : super(pointer);

  @override
  bool exec() {
    _pointer.write(_ins.output, _pointer.input);
    return super.exec();
  }
}

class OutputOp extends Operation {
  final opcode = 4;
  final params = 1;
  final hasOutput = false;

  OutputOp(MemPointer pointer) : super(pointer);

  @override
  bool exec() {
    _pointer.output = _ins[0].value;
    return super.exec();
  }
}

abstract class JumpOp extends Operation {
  final params = 2;
  bool ifTrue = false;
  bool jumped = false;
  final hasOutput = false;

  JumpOp(MemPointer pointer) : super(pointer);

  @override
  bool exec() {
    jumped = ifTrue ? _ins[0] != 0 : _ins[0] == 0;
    if (jumped) _pointer(_ins[1].value);
    return super.exec();
  }

  @override
  advancePointer() {
    if (!jumped) _pointer.advance(params + 1);
  }
}

class JumpIfTrueOp extends JumpOp {
  final opcode = 5;

  JumpIfTrueOp(MemPointer pointer) : super(pointer) {
    ifTrue = true;
  }
}

class JumpIfFalseOp extends JumpOp {
  final opcode = 6;

  JumpIfFalseOp(MemPointer pointer) : super(pointer);
}

class LessThanOp extends Operation {
  final opcode = 7;

  LessThanOp(MemPointer pointer) : super(pointer);

  @override
  bool exec() {
    _pointer.write(_ins.output, _ins[0] < _ins[1] ? 1 : 0);
    return super.exec();
  }
}

class EqualsOp extends Operation {
  final opcode = 8;

  EqualsOp(MemPointer pointer) : super(pointer);

  @override
  bool exec() {
    _pointer.write(_ins.output, _ins[0] == _ins[1] ? 1 : 0);
    return super.exec();
  }
}

class HaltOp extends Operation {
  final params = 0;
  final hasOutput = false;

  HaltOp(MemPointer pointer) : super(pointer);

  @override
  bool exec() => true;
}
