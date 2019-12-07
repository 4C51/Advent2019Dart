import 'package:AdventCommon/rocketry.dart';
import 'package:AdventCore/core.dart';

class Amplifier {
  final computer = Intcode();
  int phaseSetting;
  Amplifier nextAmp;

  Amplifier(String ctrlProgram) {
    computer.loadProgram(ctrlProgram);
  }

  start(int signal) {
    if (phaseSetting == null) throw 'No phase setting!';
    computer.reset();
    computer.execute([phaseSetting, signal]);
    return nextAmp?.start(computer.outputLast) ?? computer.outputLast;
  }

  setPhase(int phase) => phaseSetting = phase;

  get output => computer.outputLast;
}

class AmpCircuit {
  final ampCount;
  final ctrlProgram;
  List<Amplifier> amplifiers = List();
  int _max = 0;
  List<int> _maxPhases;

  AmpCircuit(this.ctrlProgram, [this.ampCount = 5]) {
    for (var i = 0; i < ampCount; i++) {
      var amp = Amplifier(ctrlProgram);
      if (amplifiers.isNotEmpty) amplifiers.last?.nextAmp = amp;
      amplifiers.add(amp);
    }
  }

  _setPhases(List<int> phases) {
    for (var i = 0; i < phases.length; i++) {
      amplifiers[i].setPhase(phases[i]);
    }
  }

  findMax(int signal) {
    var phasePerms = Permutations<int>([for (var i = 0; i < ampCount; i++) i]);
    phasePerms.forEach((phases) {
      _setPhases(phases);
      var ampSignal = amplifiers.first.start(signal);
      if (ampSignal > _max) {
        _max = ampSignal;
        _maxPhases = phases;
      }
    });

    return _max;
  }

  get max => _max;
  get maxPhases => _maxPhases;
}
