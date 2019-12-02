import 'package:AdventCore/data_structures.dart';
import 'sleep_minute.dart';
import 'guard_shift.dart';

final guardRegex = new RegExp(r'Guard #(\d+)');

class Guard {
  Set<GuardShift> shifts = new Set();
  int id;

  Guard(int this.id) {
    
  }

  addShift(GuardShift shift) {
    shifts.add(shift);
  }

  BucketCounter<SleepMinute> getSleepFrequency() {
    return shifts.fold(new BucketCounter<SleepMinute>(), (bucket, guardShift) => bucket..addMany(guardShift.sleep.sleepMinutes));
  }
  
  SleepMinute get sleepiestMinute {
    return getSleepFrequency().highestCount.first.key;
  }

  MapEntry<SleepMinute, int> get sleepiestMinuteCount {
    return getSleepFrequency().highestCount?.first;
  }

  int get totalSleep {
    return shifts.fold(0, (currentSleep, shift) => currentSleep + shift.sleep.duration);
  }

  static Guard fromLogEntry(String entry) {
    var guardId = int.tryParse(guardRegex.firstMatch(entry)?.group(1) ?? '');

    return guardId != null ? new Guard(guardId) : null;
  }

  @override
  get hashCode {
    return id;
  }

  @override
  bool operator ==(other){
    return id == other.id;
  }
}