import 'guard_shift.dart';

final logEntryRegex = new RegExp(r'\[(.+?)\](?: Guard #(\d+))? (.+)');
enum ShiftLogAction {
  WakeUp,
  FallAsleep,
  BeginShift
}
const shiftLogActionMap = {
  'wakes up': ShiftLogAction.WakeUp,
  'falls asleep': ShiftLogAction.FallAsleep,
  'begins shift': ShiftLogAction.BeginShift
};

class ShiftLogEntry {
  ShiftLogAction action;
  DateTime date;
  GuardShift shift;

  ShiftLogEntry(DateTime this.date, ShiftLogAction this.action, [GuardShift this.shift]) {

  }

  setShift(GuardShift shift) {
    this.shift = shift;
    shift.addEntry(this);
  }

  static ShiftLogEntry fromLogEntry(String entry) {
    var logArgs = logEntryRegex.firstMatch(entry).groups([1, 2, 3]).toList();
    var logDate = DateTime.parse(logArgs[0]);
    var action = shiftLogActionMap[logArgs[2]];
    
    return new ShiftLogEntry(logDate, action);
  }
}