import 'package:AdventCore/data_structures.dart';

import 'guard.dart';
import 'shift_log_entry.dart';
import 'shift_sleep.dart';

class GuardShift {
  Guard guard;
  Set<ShiftLogEntry> log = new Set();
  bool shiftClosed = false;
  ShiftSleep sleep = new ShiftSleep();
  ShiftLogEntry _sleepStart;

  GuardShift(Guard this.guard) {
    guard.addShift(this);
  }

  addEntry(ShiftLogEntry entry) {
    log.add(entry);

    _calcSleep(entry);
  }

  _calcSleep(ShiftLogEntry entry) {
    switch (entry.action) {
      case ShiftLogAction.FallAsleep:
        _sleepStart = entry;
        break;
      case ShiftLogAction.WakeUp:
        sleep.addSession(new DateTimeRange(_sleepStart.date, entry.date));
        _sleepStart = null;
        break;
      default:
    }
  }
}