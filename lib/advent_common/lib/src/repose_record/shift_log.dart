import 'guard_shift.dart';
import 'guard.dart';
import 'shift_log_entry.dart';

class ShiftLog {
  Set<Guard> guards = new Set();
  Set<ShiftLogEntry> entries = new Set();

  ShiftLog(List<String> entries) {
    entries.sort();
    var currentShift;

    for (var entry in entries) {
      var freshGuard = Guard.fromLogEntry(entry);
      freshGuard = guards.lookup(freshGuard) ?? freshGuard;

      if (freshGuard != null) {
        guards.add(freshGuard);
        currentShift = new GuardShift(freshGuard);
      }

      this.entries.add(ShiftLogEntry.fromLogEntry(entry)..setShift(currentShift));
    }
  }

  Guard get sleepiestGuard {
    return guards.fold(null, (sleepiest, guard) => (sleepiest?.totalSleep ?? 0) > guard.totalSleep ? sleepiest : guard);
  }

  Guard get sleepiestGuardMinute {
    return guards.fold(null, (sleepiest, guard) => (sleepiest?.sleepiestMinuteCount?.value ?? 0) > (guard.sleepiestMinuteCount?.value ?? 0) ? sleepiest : guard);
  }
}