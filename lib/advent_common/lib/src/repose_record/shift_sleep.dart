import 'package:AdventCore/data_structures.dart';
import 'sleep_minute.dart';

class ShiftSleep {
  List<DateTimeRange> sleepSessions = new List();
  Set<SleepMinute> sleepMinutes = new Set();

  ShiftSleep([DateTimeRange sleepSession]) {
    if (sleepSession != null) addSession(sleepSession);
  }

  addSession(DateTimeRange session) {
    sleepSessions.add(session);
    
    sleepMinutes.add(new SleepMinute(session.start.hour, session.start.minute));
    for (var minute = 0; minute < session.duration.inMinutes; minute++) {
      var current = session.start.add(new Duration(minutes: minute));
      sleepMinutes.add(new SleepMinute(current.hour, current.minute));
    }
  }

  int get duration {
    return sleepMinutes.length;
  }

  bool asleepAt(DateTime time) {
    return sleepMinutes.contains(time);
  }
}