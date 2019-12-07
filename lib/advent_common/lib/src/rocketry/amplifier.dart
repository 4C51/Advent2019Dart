import 'package:AdventCommon/rocketry.dart';
import 'package:AdventCore/core.dart';

class Amplifier {
  final computer = IntcodeComputer();
  int phaseSetting;
  Amplifier nextAmp;

  Amplifier(String ctrlProgram) {
    computer.loadProgram('control', ctrlProgram);
  }

  Future<IO> start(int signal) async {
    if (phaseSetting == null) throw 'No phase setting!';
    var result = await computer
        .run('control', input: [phaseSetting, signal]).then<IO>((result) {
      return Future.value(nextAmp?.start(result.last) ?? result);
    });

    //var output = await nextAmp?.start(result.last) ?? result.last;
    return result;
  }

  setPhase(int phase) => phaseSetting = phase;
}

class AmpCircuit {
  final ampCount;
  final ctrlProgram;
  List<Amplifier> amplifiers = List();
  int _max = 0;
  List<int> _maxPhases;

  AmpCircuit(this.ctrlProgram, {loop = false, this.ampCount = 5}) {
    for (var i = 0; i < ampCount; i++) {
      var amp = Amplifier(ctrlProgram);
      if (amplifiers.isNotEmpty) amplifiers.last?.nextAmp = amp;
      amplifiers.add(amp);
    }

    if (loop) {
      amplifiers.last.nextAmp = amplifiers.first;
    }
  }

  _setPhases(List<int> phases) {
    for (var i = 0; i < phases.length; i++) {
      amplifiers[i].setPhase(phases[i]);
    }
  }

  findMax(int signal) async {
    var phasePerms = Permutations<int>([for (var i = 0; i < ampCount; i++) i]);

    var run = (phases) async {
      _setPhases(phases);
      var ampSignal = await amplifiers.first.start(signal);
      if (ampSignal.last > _max) {
        _max = ampSignal.last;
        _maxPhases = phases;
      }
    };

    var iter = phasePerms.iterator;
    while (iter.moveNext()) {
      await (run(iter.current));
    }

    return _max;
  }

  findMaxLoop(int signal) {
    var phasePerms =
        Permutations<int>([for (var i = 5; i < 5 + ampCount; i++) i]);
    phasePerms.forEach((phases) async {
      _setPhases(phases);
      var ampSignal = await amplifiers.first.start(signal);
      if (ampSignal.last > _max) {
        _max = ampSignal.last;
        _maxPhases = phases;
      }
    });

    return _max;
  }

  get max => _max;
  get maxPhases => _maxPhases;
}
